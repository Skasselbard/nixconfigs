{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  dyndnsScript = ''
        #!/bin/bash

        # Configuration
        HOSTED_ZONE_ID="${config.services.dyndns.hostedZoneId}"
        RECORD_NAME="${config.services.dyndns.recordName}"
        TTL=${toString config.services.dyndns.ttl}
        TYPE="${config.services.dyndns.recordType}"

        # Fetch current public IP
        CURRENT_IP=$(curl -s ${config.services.dyndns.ipFetchUrl})
        if [[ -z "$CURRENT_IP" ]]; then
            echo "Failed to retrieve public IP address."
            exit 1
        fi

        echo "Current IP: $CURRENT_IP"

        # Fetch the existing DNS record's IP
        DNS_IP=$(aws route53 list-resource-record-sets \
            --hosted-zone-id "$HOSTED_ZONE_ID" \
            --query "ResourceRecordSets[?Name == \`$RECORD_NAME.\` && Type == \`$TYPE\`].ResourceRecords[0].Value" \
            --output text)

        if [[ -z "$DNS_IP" ]]; then
            echo "Failed to retrieve current DNS IP address for $RECORD_NAME."
            exit 1
        fi
        echo "Current DNS IP: $DNS_IP"

        # Compare the two IPs
        if [[ "$CURRENT_IP" == "$DNS_IP" ]]; then
            echo "No update needed. Public IP matches the current DNS record."
            exit 0
        fi

        echo "IP mismatch detected. Updating Route 53..."

        # Create JSON payload for updating Route 53
        CHANGE_BATCH=$(cat <<EOF
        {
            "Comment": "Update record to current IP",
            "Changes": [
                {
                    "Action": "UPSERT",
                    "ResourceRecordSet": {
                        "Name": "$RECORD_NAME",
                        "Type": "$TYPE",
                        "TTL": $TTL,
                        "ResourceRecords": [
                            {
                                "Value": "$CURRENT_IP"
                            }
                        ]
                    }
                }
            ]
        }
    EOF
        )

        # Update Route 53 record
        aws route53 change-resource-record-sets \
            --hosted-zone-id "$HOSTED_ZONE_ID" \
            --change-batch "$CHANGE_BATCH"

        if [[ $? -eq 0 ]]; then
            echo "Route 53 record updated successfully."
        else
            echo "Failed to update Route 53 record."
        fi
  '';
in
{
  options.services.dyndns = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the dynamic DNS updater service.";
    };

    hostedZoneId = mkOption {
      type = types.str;
      description = "The Route 53 hosted zone ID.";
    };

    recordName = mkOption {
      type = types.str;
      description = "The DNS record name to update.";
    };

    ttl = mkOption {
      type = types.int;
      default = 300;
      description = "Time-to-live for the DNS record.";
    };

    recordType = mkOption {
      type = types.str;
      default = "A";
      description = "DNS record type (e.g., A for IPv4, AAAA for IPv6).";
    };

    ipFetchUrl = mkOption {
      type = types.str;
      default = "https://checkip.amazonaws.com";
      description = "URL to fetch the current public IP address.";
    };
  };

  config = mkIf config.services.dyndns.enable {
    environment.systemPackages = with pkgs; [
      awscli
      curl
    ];
    systemd.services.dyndns = {
      description = "Dynamic DNS updater for Route 53";
      script = dyndnsScript;
      serviceConfig = {
        Environment = "PATH=${pkgs.coreutils}/bin:${pkgs.curl}/bin:${pkgs.awscli}/bin";
        Restart = "on-failure";
      };
    };

    systemd.timers.dyndns = {
      description = "Dynamic DNS updater timer";
      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = "15m";
      };
      wantedBy = [ "timers.target" ];
    };
  };
}

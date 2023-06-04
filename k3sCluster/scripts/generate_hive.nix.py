# result:
# {
#   {{host1.name}} = {
#     imports = [ {{host1.config}}.nix ];
#     deployment.targetHost = {{host1.ip}}
#   };
#
#   ...
#
#   {{hostN.name}} = {
#     imports = [ {{hostN.config}}.nix ];
#     deployment.targetHost = {{hostN.ip}}
#   };
# }

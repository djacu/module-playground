{lib, config, ...}: let
  cfg = config.zpoolprops;
  types = lib.types;
in {
  options.zpoolprops = {
    ashift = lib.mkOption {
        type = lib.types.int;
        default = 0;
    };
    autotrim = lib.mkOption {
        type = lib.types.enum ["on" "off"];
        default = "off";
    };
    output = lib.mkOption {
        type = lib.types.str;
    };
  };

  config.zpoolprops = {
    output = let
      cleanCfg = removeAttrs cfg [ "output" ];
      stringCfg = lib.mapAttrs (name: value: builtins.toString value) cleanCfg;
      setCfg = lib.mapAttrsToList (name: value: name + "=" + value) stringCfg;
    in
      lib.concatMapStrings (x: "-o " + x + " \\\n") setCfg;
  };
}

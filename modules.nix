{lib, config, ...}: let
  cfg = config.zpoolprops;
  types = lib.types;
in {
  options.zpoolprops = {
    ashift = lib.mkOption {
        default = 0;
        type = lib.types.int;
        apply = builtins.toString;
    };
    autotrim = lib.mkOption {
        type = lib.types.enum ["on" "off"];
        default = "off";
        apply = builtins.toString;
    };
    output = lib.mkOption {
        type = lib.types.str;
        internal = true;
    };
  };

  config.zpoolprops = {
    output = let
      cleanCfg = removeAttrs cfg [ "output" ];
      setCfg = lib.mapAttrsToList (name: value: name + "=" + value) cleanCfg;
    in
      lib.concatMapStrings (x: "    -o " + x + " \\\n") setCfg;
  };
}

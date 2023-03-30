{lib, config, ...}: let
  cfg = config.playground;
in {
  options.playground = {
    enable = lib.mkEnableOption "playground";
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

  config.playground = {
    output = let
      cleanCfg = removeAttrs cfg [ "output" "enable" ];
      stringCfg = lib.mapAttrs (name: value: builtins.toString value) cleanCfg;
      setCfg = lib.mapAttrsToList (name: value: name + "=" + value) stringCfg;
    in
      lib.concatMapStrings (x: "-o " + x + " \\\n") setCfg;
      #"Obi Wan: Hello there!\n" + (lib.concatMapStrings  (x: "-o " + x + "\n") (map toString (lib.attrValues (cfg // {output=null;}))));
  };
}

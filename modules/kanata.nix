{ ... }:
{
  services.kanata = {
    enable = true;
    keyboards = {
      "internal".config = ''
        (defsrc caps)
        (deflayer base lctl)
      '';
    };
  };
}

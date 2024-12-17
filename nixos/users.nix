{ pkgs, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.fish;
    users = {
      william = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "libvirtd"
        ];
      };
    };
  };
}

{ pkgs, ... }:
{
  # Virtualisation
  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
        runAsRoot = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };
  systemd.services.libvirtd = {
    path =
      let
        env = pkgs.buildEnv {
          name = "qemu-hook-env";
          paths = with pkgs; [
            bash
            libvirt
            kmod
            systemd
            ripgrep
            sd
          ];
        };
      in
      [ env ];

    preStart = ''
      mkdir -p /var/lib/libvirt/hooks
      mkdir -p /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin
      mkdir -p /var/lib/libvirt/hooks/qemu.d/win11/release/end

      ln -sf /etc/libvirt/hooks/qemu /var/lib/libvirt/hooks/qemu
      ln -sf /etc/libvirt/hooks/qemu.d/win11/prepare/begin/start.sh /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin/start.sh
      ln -sf /etc/libvirt/hooks/qemu.d/win11/release/end/finish.sh /var/lib/libvirt/hooks/qemu.d/win11/release/end/finish.sh

      chmod +x /var/lib/libvirt/hooks/qemu
      chmod +x /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin/start.sh
      chmod +x /var/lib/libvirt/hooks/qemu.d/win11/release/end/finish.sh
    '';
  };
}

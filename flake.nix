{
  description = ''
    Klogg is a multi-platform GUI application that helps browse and search
    through long and complex log files. It is designed with programmers and
    system administrators in mind and can be seen as a graphical, interactive
    combination of grep, less, and tail.
  '';

  outputs = { self, nixpkgs }: let 
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    inherit (pkgs) stdenv lib;
  in {
    defaultPackage.x86_64-linux = self.packages.x86_64-linux.klogg;
    packages.x86_64-linux.klogg = let 
      qt = pkgs.qt515;
      libqt = pkgs.libsForQt515;
    in stdenv.mkDerivation rec {
      pname = "klogg";
      version = "20.12";
      qmakeFlags = [ "VERSION=${version}" ];

      src = ./.;

      nativeBuildInputs = with pkgs; [
        cmake
        pkg-config
        qt.wrapQtAppsHook

        libqt.karchive
        libuchardet
        hyperscan
        xxHash
      ];

      buildInputs = with pkgs; [ 
        qt.qtbase
        tbb
        python3
        ragel
        boost
      ];

      meta = with pkgs.lib; {
        description = "The faster, smart log explorer";
        longDescription = ''
          Klogg is a multi-platform GUI application that helps browse and search
          through long and complex log files. It is designed with programmers and
          system administrators in mind and can be seen as a graphical, interactive
          combination of grep, less, and tail.
        '';
        homepage = "https://klogg.filimonov.dev/";
        license = licenses.gpl3Plus;
        platforms = platforms.unix;
      };
    };
  };
}

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
    qt = pkgs.qt515;
    libqt = pkgs.libsForQt515;
  in {
    defaultPackage.x86_64-linux = self.packages.x86_64-linux.klogg;
    packages.x86_64-linux.klogg = stdenv.mkDerivation rec {
      pname = "klogg";
      version = "20.12";

      src = ./.;

      nativeBuildInputs = with pkgs; [
        pkg-config
        cmake
        qt.wrapQtAppsHook
        hyperscan
        libuchardet
        xxHash
        libqt.karchive
      ];
      buildInputs = with pkgs; [ 
        tbb
        python3
        qt.qtbase
        qt.qmake
        ragel
        boost
      ];

      qmakeFlags = [ "VERSION=${version}" ];
      enableParallelBuilding = true;

      postPatch = lib.optionalString stdenv.isDarwin ''
        substituteInPlace glogg.pro \
          --replace "boost_program_options-mt" "boost_program_options"
      '';

      postInstall = lib.optionalString stdenv.isDarwin ''
        mkdir -p $out/Applications
        mv $out/bin/glogg.app $out/Applications/glogg.app
        rm -fr $out/{bin,share}
        wrapQtApp $out/Applications/glogg.app/Contents/MacOS/glogg
      '';

      meta = with pkgs.lib; {
        description = "The fast, smart log explorer";
        longDescription = ''
          A multi-platform GUI application to browse and search through long or complex log files. It is designed with programmers and system administrators in mind. glogg can be seen as a graphical, interactive combination of grep and less.
        '';
        homepage = "https://glogg.bonnefon.org/";
        license = licenses.gpl3Plus;
        platforms = platforms.unix;
        maintainers = with maintainers; [ c0bw3b ];
      };
    };
  };
}

let
  pkgs = import <nixpkgs> {};
  fms=  import ./nix/fms;
  nceplibs=  import ./nix/nceplibs;
  esmf=  import ./nix/esmf;
  cc = pkgs.gfortran.cc;
in
with import <nixpkgs> {}; {
  qpidEnv = stdenvNoCC.mkDerivation {
    name = "my-gcc8-environment";
    buildInputs = [
        cc
        fms
        esmf
        nceplibs
        gfortran
        netcdffortran
        openmpi
    ];

    FMS_DIR="${fms}/include";
    ESMF_DIR="${esmf}";
    #LD_LIBRARY_PATH="$${LD_LIBRARY_PATH}:${esmf}/lib/libO3/Linux.gfortran.64.mpiuni.default/:${fms}/libFMS/.libs/:$${SERIALBOX_DIR}/lib";
    INCLUDE="-I${fms}/include -I${netcdffortran}/include -I${esmf}/mod/modO3/Linux.gfortran.64.mpiuni.default/";
    OMPI_CC="${cc}/bin/gcc";
};
}


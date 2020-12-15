{ lib
, stdenv
, python39Packages
, pkgs
, maintainers
}:

let
  pypi = python39Packages;

  buildPythonPackage = pypi.buildPythonPackage;
  fetchPypi = pypi.fetchPypi;
in buildPythonPackage rec {
  pname = "virtualfish";
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17w9q4cyz9psrcy2zcawlzi7pqwbxiv4mgnxzn6dba9zksn5gk4w";
  };

  buildInputs = with pypi; [
    pip
    pytest
    pkgs.which
  ];
  propagatedBuildInputs = with pypi; [
    psutil
    virtualenv
    packaging
    pkgconfig
  ];

  meta = {
    description = "VirtualFish is a Python virtual environment manager for the Fish shell.";
    homepage = "https://github.com/justinmayer/virtualfish";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jeffh ];
  };
}

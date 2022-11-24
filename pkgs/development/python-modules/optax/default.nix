{ absl-py
, buildPythonPackage
, chex
, fetchFromGitHub
, jaxlib
, lib
, numpy
, callPackage
}:

buildPythonPackage rec {
  pname = "optax";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-BvmRFA1KNS7F6kozH9LMG8v4XJY/T2DwKgf9IIY2shE=";
  };

  outputs = [
    "out"
    "testsout"
  ];

  buildInputs = [ jaxlib ];

  propagatedBuildInputs = [
    absl-py
    chex
    numpy
  ];

  postInstall = ''
    mkdir $testsout
    cp -R examples $testsout/examples
  '';

  pythonImportsCheck = [
    "optax"
  ];

  # check in passthru.tests.pytest to escape infinite recursion with flax
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    description = "Optax is a gradient processing and optimization library for JAX.";
    homepage = "https://github.com/deepmind/optax";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}

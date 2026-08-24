# typed: false
# frozen_string_literal: true

class Quarry < Formula
  include Language::Python::Virtualenv

  desc "Local semantic search engine — extract searchable knowledge from any document"
  homepage "https://github.com/punt-labs/quarry"
  url "https://files.pythonhosted.org/packages/e1/15/3c239f495df2bd35a0a03d6b3940bb9a38a70e96b72504189eed1cf75eab/punt_quarry-3.0.3.tar.gz"
  sha256 "4483b28b9892cf5143ad36561b695187fc3038d8fa4a57e01ba37176b0e99a89"
  license "MIT"

  depends_on "cmake" => :build # aws-lc-sys (hf-xet's TLS backend)
  depends_on "rust" => :build # cryptography, pydantic-core, rpds-py, tokenizers, hf-xet
  depends_on "apache-arrow" # pyarrow links against the system Arrow C++
  depends_on "geos" # shapely
  depends_on "jpeg-turbo" # pillow
  depends_on "libyaml" # pyyaml
  depends_on "python@3.13"
  uses_from_macos "libxml2" # lxml
  uses_from_macos "libxslt" # lxml

  # lancedb and onnxruntime (below) ship no macOS x86_64 wheel at these pinned
  # versions -- Intel is unsupported until upstream publishes one.
  on_macos do
    depends_on arch: :arm64
  end

  # lancedb and onnxruntime ship wheel-only on PyPI (no sdist), so
  # brew update-python-resources cannot generate these two automatically --
  # hand-pinned to the wheel matching each supported platform/arch instead.
  # See punt-kit/patterns/homebrew-pypi-formula.md for the full story.
  resource "lancedb" do
    on_macos do
      url "https://files.pythonhosted.org/packages/23/2f/4ddcab82bb618c6c8de00725f3cf59585dcb9040964dde13cb0cae6ed3cd/lancedb-0.37.1-cp310-abi3-macosx_11_0_arm64.whl"
      sha256 "c15c46f23cf6959c79fb93cdba2c76536cf784d3134386662da03dc6ccac3c26"
    end
    on_linux do
      on_arm do
        url "https://files.pythonhosted.org/packages/e5/5e/dac0fd9478a21685444f23e6ec937babf4ff48b1616b68e8137778d6ecb9/lancedb-0.37.1-cp310-abi3-manylinux_2_28_aarch64.whl"
        sha256 "35d872d920cbfdc3771fbcd33f2c63bff6ff7203d6d2ba8fe4330e98eb859d12"
      end
      on_intel do
        url "https://files.pythonhosted.org/packages/1f/fa/ee1cdb1e904872d75fa0ff44ad35cd23494e810299c33e68de0687de7a71/lancedb-0.37.1-cp310-abi3-manylinux_2_28_x86_64.whl"
        sha256 "86597f4dbc51a33a07341550dc77d21a1ddd1f7539266eda5bb64c4f3bd11cca"
      end
    end
  end

  resource "onnxruntime" do
    on_macos do
      url "https://files.pythonhosted.org/packages/41/f8/d375facf60edaf41f5732f9f689c98a800fcc52df5cf6ddfb406703eb5a1/onnxruntime-1.29.0-cp313-cp313-macosx_14_0_arm64.whl"
      sha256 "be0f8ed688cfb1d4d5765a137193b7bfab0c8ea214eed99260b380bb525a3a7f"
    end
    on_linux do
      on_arm do
        url "https://files.pythonhosted.org/packages/c9/17/b9ad04051a8c4f504852ce0e8e10f9a6b2f1a331eedcdcc503df776dd0ea/onnxruntime-1.29.0-cp313-cp313-manylinux_2_28_aarch64.whl"
        sha256 "d67673c5367727860922c5262d724472f1b5539fb7ccf4c81a638f9b71719803"
      end
      on_intel do
        url "https://files.pythonhosted.org/packages/83/2c/d8eb945d2a372149df9705a8d5c8d7c6c46c987c5446dbcea9e1ea7f6556/onnxruntime-1.29.0-cp313-cp313-manylinux_2_28_x86_64.whl"
        sha256 "e2128f31f449e922c62dbe5d8b6b7b079f0bcaf2d56a102fa203cb6e5bb5ab19"
      end
    end
  end

  # pymupdf vendors and builds its own full MuPDF + Tesseract + a dozen
  # third-party C libraries from source when built from sdist -- one of the
  # heaviest, most fragile source builds in the Python ecosystem, and one
  # PyMuPDF itself doesn't expect anyone to do (its own docs assume the
  # wheel). Pin the wheel here rather than fight the from-source build the
  # way lancedb/onnxruntime are handled above.
  resource "pymupdf" do
    on_macos do
      url "https://files.pythonhosted.org/packages/fa/01/3591f781b417b382a8487a2356e927acfe858b1043bab0ec47f6805bb109/pymupdf-1.28.2-cp310-abi3-macosx_11_0_arm64.whl"
      sha256 "7113846b35dbf0a033f088e4f4fb543dabeb4b0b12c112966a1ca1ee2d5eacae"
    end
    on_linux do
      on_arm do
        url "https://files.pythonhosted.org/packages/d2/86/4a68f080b71b46802178346af46486e1697508e760855ff5f3b218a6dff7/pymupdf-1.28.2-cp310-abi3-manylinux_2_28_aarch64.whl"
        sha256 "3050a233dde1211efe89ada74e2add6238436434159f46097a1423aad2842545"
      end
      on_intel do
        url "https://files.pythonhosted.org/packages/c7/06/dace3e27af26690cb20bead80dbac42941b0841eb689b8aabbd67dde16f0/pymupdf-1.28.2-cp310-abi3-manylinux_2_28_x86_64.whl"
        sha256 "397d6715c1f0df7548a92d0afd8ce370fc48fa47aeefac16be2bc04a16a8227f"
      end
    end
  end

  # tree-sitter-c-sharp's sdist build compiles parser.c but not its external
  # scanner.c, so the built extension dlopens successfully yet crashes on
  # first real use: "symbol not found ... _tree_sitter_c_sharp_external_
  # scanner_create". Caught by actually running `quarry doctor`, not
  # `brew test` -- doctor imports the code_extractor path that pulls this
  # in. Wheel resource sidesteps the broken sdist build entirely.
  resource "tree-sitter-c-sharp" do
    on_macos do
      url "https://files.pythonhosted.org/packages/c8/13/593c8603f834eaf15082b81e079289fc9f062b4c0ab5b9489134084eec06/tree_sitter_c_sharp-0.23.5-cp310-abi3-macosx_11_0_arm64.whl"
      sha256 "a75994a11f6fed3f5b8c36ad6a00e5dc43205bd912c43af3a2a54fdf649664eb"
    end
    on_linux do
      on_arm do
        url "https://files.pythonhosted.org/packages/0a/c8/e0f391e343f5424d0627e3b6886c77baeb1249a3f10986be00b0b64ecdab/tree_sitter_c_sharp-0.23.5-cp310-abi3-manylinux2014_aarch64.manylinux_2_17_aarch64.manylinux_2_28_aarch64.whl"
        sha256 "3ea38fb095d85d360dc5a0bec2fa605e496228876f798c9e089d5f0e72bcef46"
      end
      on_intel do
        url "https://files.pythonhosted.org/packages/41/5a/a8855cbb5bbab28adb29c2c7f0e7be5a9f1d21450c13b3c3e613190d9b8c/tree_sitter_c_sharp-0.23.5-cp310-abi3-manylinux1_x86_64.manylinux_2_28_x86_64.manylinux_2_5_x86_64.whl"
        sha256 "aa88a780204cd153c4c1ae2d59c654cee1402212fa0d069823d6d34301587438"
      end
    end
  end

  # Same external-scanner-not-compiled bug as tree-sitter-c-sharp above --
  # tree-sitter-embedded-template has no external scanner and built fine
  # from sdist, but yaml does and hits the identical dlopen symbol failure.
  resource "tree-sitter-yaml" do
    on_macos do
      url "https://files.pythonhosted.org/packages/18/0d/15a5add06b3932b5e4ce5f5e8e179197097decfe82a0ef000952c8b98216/tree_sitter_yaml-0.7.2-cp310-abi3-macosx_11_0_arm64.whl"
      sha256 "0807b7966e23ddf7dddc4545216e28b5a58cdadedcecca86b8d8c74271a07870"
    end
    on_linux do
      on_arm do
        url "https://files.pythonhosted.org/packages/89/59/61f1fed31eb6d46ff080b8c0d53658cf29e10263f41ef5fe34768908037a/tree_sitter_yaml-0.7.2-cp310-abi3-manylinux2014_aarch64.manylinux_2_17_aarch64.manylinux_2_28_aarch64.whl"
        sha256 "88636d19d0654fd24f4f242eaaafa90f6f5ebdba8a62e4b32d251ed156c51a2a"
      end
      on_intel do
        url "https://files.pythonhosted.org/packages/72/92/c4b896c90d08deb8308fadbad2210fdcc4c66c44ab4292eac4e80acb4b61/tree_sitter_yaml-0.7.2-cp310-abi3-manylinux1_x86_64.manylinux_2_28_x86_64.manylinux_2_5_x86_64.whl"
        sha256 "f1a5c60c98b6c4c037aae023569f020d0c489fad8dc26fdfd5510363c9c29a41"
      end
    end
  end

  # Remaining resource stanzas are regenerated by:
  #   brew update-python-resources quarry --ignore-main-package-cooldown --ignore-errors
  # on every release bump. lancedb/onnxruntime/pymupdf/tree-sitter-c-sharp/
  # tree-sitter-yaml all have valid PyPI sdists (or none, for the first two)
  # that the generator will happily re-add below as ordinary tarball
  # resources -- a later `resource "name"` silently overrides the earlier
  # hand-pinned wheel one with the same name, re-breaking the exact bugs
  # those five exist to work around. Delete any regenerated duplicate of
  # those five names before committing.

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/5f/56/a8120250d128bed162cd73c76d45f6ef9991f3e068f62a8ee060afa3104a/annotated_types-0.8.0.tar.gz"
    sha256 "13b2beaad985e05e2d6407ee4c4f35590b11f8d693a258a561055cac8f64cab7"
  end

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/3e/38/7859ff46355f76f8d19459005ca000b6e7012f2f1ca597746cbcd1fbfe5e/antlr4-python3-runtime-4.9.3.tar.gz"
    sha256 "f224469b4168294902bb1efa80a8bf7855f24c99aef99cbefc1bcd3cce77881b"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/a3/c2/24167ea9858356b47a87a50d39908bfdb72ceeefe0041586e704e5376b3a/certifi-2026.7.22.tar.gz"
    sha256 "741e2c3b351ddf169a738da9f2c048608ff7f2c5cc02f1ebc6b118bb090d5d55"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/9e/ef/008a1939e372c06329a3fce4279c02f328488f3526744906eeec3da7ad5f/cffi-2.1.1.tar.gz"
    sha256 "dd31f52ea1086513bb9df30f8fcee9b8918323ae067a3d5b78bc826a000712be"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/8c/55/ba79756cb90c8d69d599d57785398ac87bba7b19c80e87f4e8a562197c93/colorlog-6.12.0.tar.gz"
    sha256 "2a7924c1dadf18b22a0eb8b06d1c7b01d5341707ec1641eb6fcc4fde0c3e8e5f"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/de/41/6cbdcf9142d00fe82836fbb51e503e58088575cf7a0fe1dbff6695bf0840/cryptography-50.0.0.tar.gz"
    sha256 "eeac2acb5a20ed25e0ad6d1df9891a520b78b404266b6d11778f25d5d691a6c9"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "et-xmlfile" do
    url "https://files.pythonhosted.org/packages/d3/38/af70d7ab1ae9d4da450eeec1fa3918940a5fafb9055e934af8d6eb0c2313/et_xmlfile-2.0.0.tar.gz"
    sha256 "dab3f4764309081ce75662649be815c4c9081e88f0837825f90fd28317d4da54"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/8a/02/91e3416a8fdd715abb903a952a6bec7cdd8d14eed55d415fc8595524c319/fastapi-0.141.1.tar.gz"
    sha256 "e8822fc40db1e1858054d7a949a888695bc9bdce70139178e33bd2871a453ca1"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/7d/64/a02e6765de08964ed371eca577870593245afc9dfac16d037de7c10d18e6/filelock-3.32.3.tar.gz"
    sha256 "0ffa185a3540854c95caa7fa76b76cb219d907415e2c5dc9af25fd970563487f"
  end

  resource "flatbuffers" do
    url "https://files.pythonhosted.org/packages/e8/2d/d2a548598be01649e2d46231d151a6c56d10b964d94043a335ae56ea2d92/flatbuffers-25.12.19-py2.py3-none-any.whl"
    sha256 "7634f50c427838bb021c2d66a3d1168e9d199b0607e6329399f04846d42e20b4"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/00/78/f34251dadb8f3921264a1d9b8946f5e542014ee2614b285261b4e40e6775/fsspec-2026.7.0.tar.gz"
    sha256 "c803c40f4cf860b49dea58ee3e1c33cb9c790520e233537e1340049f89b82a88"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/1b/ab/522a2ab67f27971a9d48ca666d4fca85ef7d5282d142e31fd087e27b1bbe/hf_xet-1.6.0.tar.gz"
    sha256 "2e58454a340b3556dfa4972d5451aff4fba8dd42a236600ba1a1d2b1514f0fef"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx-sse" do
    url "https://files.pythonhosted.org/packages/0f/4c/751061ffa58615a32c31b2d82e8482be8dd4a89154f003147acee90f2be9/httpx_sse-0.4.3.tar.gz"
    sha256 "9b1ed0127459a66014aec3c56bebd93da3c1bc8bb6618c8082039a44889a755d"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/c6/ae/222a91937ebee7f62c0ca8f5ee0afd97577caf24c0abb927d1f5c7e9f6d2/huggingface_hub-1.28.0.tar.gz"
    sha256 "46a2e950c09234de54093d587d1675382f0d08dbd600d9fb599b5932f5b2c6cb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "lance-namespace" do
    url "https://files.pythonhosted.org/packages/bf/93/da5f7fcac690db9b282a3439ed9e34960c147619a0d6e1f4eb8cd240e7a5/lance_namespace-0.11.1.tar.gz"
    sha256 "f67cfbbe0647b7cb42f23b673e7edf8a75b7d8a047265a916492f8d247ee1bc2"
  end

  resource "lance-namespace-urllib3-client" do
    url "https://files.pythonhosted.org/packages/e4/c5/2bdd0ff98b469894c8a73be809d26ffdad5402517b0e5f9e758026cba29e/lance_namespace_urllib3_client-0.11.1.tar.gz"
    sha256 "145a9e9424d7597487249b5b95ee274423bf2910e1a9160b6a07b676b61ea46a"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ad/a9/970b8fa0ecc4fbf1dfaed0d89bbc1fc1421b25ec26a2038c91e872dc6c8e/lxml-6.1.2.tar.gz"
    sha256 "1055241852f2b02068af4a625a5d32c087db193c12251928af2562ecd2239f18"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markdownify" do
    url "https://files.pythonhosted.org/packages/92/ab/d1297139c0e2ceb151ae564c8c4f57ac0155d8f1f8b4cbd5d6523c82ea36/markdownify-1.2.3.tar.gz"
    sha256 "1a176f05522c8a2cb1dd3ab9d307dcdadbed5c26ae717855bfc42b3b6d38d937"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/30/d3/f9acc21dfc886e4f78e2add1a47db46ce16884346afde53f8a064c02c891/mcp-1.29.0.tar.gz"
    sha256 "52d01f334de1868cc3bb2d6604931126a67631f99a6c5d3b82ba47290315ec36"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/9a/80/db0b4559e57ec36362bedbb05530a87fafbcb6067708c946967a41d449e7/numpy-2.5.2.tar.gz"
    sha256 "d482d171c406ae88c5b19cad3b6a1c4c5209f886ab74bc44c2c865c23f52d860"
  end

  resource "omegaconf" do
    url "https://files.pythonhosted.org/packages/ce/3d/e4b57b8d9008c6ebe0d5eff901f91d5700cf7bdb8c8863df817463a7fd5e/omegaconf-2.3.1.tar.gz"
    sha256 "e5e7de64aeebeddaf8e6d3f7a783b32ac2a01c0fbd9c878012caecb891a1f42a"
  end

  resource "opencv-python" do
    url "https://files.pythonhosted.org/packages/79/4c/a438d23e09ce2033c09f7b784ad2fbdb0adf529e434101ed28f142226f98/opencv_python-5.0.0.93.tar.gz"
    sha256 "66aac3e5b5faa48d4025816592f3af19e4bfc2c68dec067bae2dbb4ca10aa9e2"
  end

  resource "opencv-python-headless" do
    url "https://files.pythonhosted.org/packages/1d/99/76b7c80252aa83c1af16393454aafd125a0287101afe8deb0a6821af0e30/opencv_python_headless-5.0.0.93.tar.gz"
    sha256 "b82f9831daab90b725c7c1ee1b36cb5732c367096ac76d119e64e14eb70d5f3c"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/3d/f9/88d94a75de065ea32619465d2f77b29a0469500e99012523b91cc4141cd1/openpyxl-3.1.5.tar.gz"
    sha256 "cf0e3cf56142039133628b5acffe8ef0c12bc902d2aadd3e0fe5878dc08d1050"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "pillow" do
    url "https://files.pythonhosted.org/packages/1c/3d/bb7fca845737cf9d7dbde16ed1843984665ff2e0a518f5db43e77ec540b9/pillow-12.3.0.tar.gz"
    sha256 "3b8182a766685eaa002637e28b4ec8d6b18819a0c71f579bf0dbaa5830297cce"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/a7/e7/0553e21d25ca4d9f573135775348a372c3ec34a93a71d5f297c3bac38341/protobuf-7.36.0.tar.gz"
    sha256 "e8e09cb0d794c6687926fa558a8a6e72aa10edb997d5ca61da0765f12a3e00ea"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/3d/e3/27f57f80141379d60defe6703eb50a707325706f07fedfd1312c7a751995/pyarrow-25.0.1.tar.gz"
    sha256 "9150a83248bfed9813ea3c3af74c3856c1984d444aa28e58bf7733b9750ddf6a"
  end

  resource "pyclipper" do
    url "https://files.pythonhosted.org/packages/f6/21/3c06205bb407e1f79b73b7b4dfb3950bd9537c4f625a68ab5cc41177f5bc/pyclipper-1.4.0.tar.gz"
    sha256 "9882bd889f27da78add4dd6f881d25697efc740bf840274e749988d25496c8e1"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1b/7d/92392ff7815c21062bea51aa7b87d45576f649f16458d78b7cf94b9ab2e6/pycparser-3.0.tar.gz"
    sha256 "600f49d217304a5902ac3c37e1281c9fe94e4d0489de643a9504c5cdfdfc6b29"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/18/a5/b60d21ac674192f8ab0ba4e9fd860690f9b4a6e51ca5df118733b487d8d6/pydantic-2.13.4.tar.gz"
    sha256 "c40756b57adaa8b1efeeced5c196f3f3b7c435f90e84ea7f443901bec8099ef6"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/9d/56/921726b776ace8d8f5db44c4ef961006580d91dc52b803c489fafd1aa249/pydantic_core-2.46.4.tar.gz"
    sha256 "62f875393d7f270851f20523dd2e29f082bcc82292d66db2b64ea71f64b6e1c1"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/68/ca/31c57507b13119d7d3cfa1576dad2911a4861e3be07b579395f4e9d393f9/pydantic_settings-2.15.0.tar.gz"
    sha256 "694b793e84f766ba76a90ebdefc01d0a9a045dab0382bee70393da93712ad117"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/3b/81/58d0ac84e1ef3a3843791d6954d94c0b33d526c75eeb1efbce9d0a4c4077/pyjwt-2.13.0.tar.gz"
    sha256 "41571c89ca91598c79e8ef18a2d07367d4810fbbd6f637794879baf1b7703423"
  end

  resource "pymupdf" do
    url "https://files.pythonhosted.org/packages/a3/fb/b6761fa2d5266f2cdb24c3b91f4023070ab7848381417678e7a289a1d52a/pymupdf-1.28.2.tar.gz"
    sha256 "5e0be7908a715aa20333caddd73f1d6f01e4cd0c26e869fa2dd0b7f344da2249"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-docx" do
    url "https://files.pythonhosted.org/packages/a9/f7/eddfe33871520adab45aaa1a71f0402a2252050c14c7e3009446c8f4701c/python_docx-1.2.0.tar.gz"
    sha256 "7bc9d7b7d8a69c9c02ca09216118c86552704edc23bac179283f2e38f86220ce"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/6a/53/ed9d74092561d4b01a2ef1349d52cdbc135e526c245f366b089cfca6de49/python_dotenv-1.2.3.tar.gz"
    sha256 "a20a594dabeaa385725aa239d5244871c143ecb356add8a20fcf23773a6c3a35"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/5b/42/55c32bb9b12693c092ad250a0e82edb5b31ddeda6eb772de5f308b3804ad/python_multipart-0.0.32.tar.gz"
    sha256 "be54b7f3fa167bb83e4fcd936b887b708f4e57fe75911c02aebf53efaf8d938e"
  end

  resource "python-pptx" do
    url "https://files.pythonhosted.org/packages/52/a9/0c0db8d37b2b8a645666f7fd8accea4c6224e013c42b1d5c17c93590cd06/python_pptx-1.0.2.tar.gz"
    sha256 "479a8af0eaf0f0d76b6f00b0887732874ad2e3188230315290cd1f9dd9cc7095"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rapidocr" do
    url "https://files.pythonhosted.org/packages/55/ed/0ee9b9281986974be9d2406ae0134c8d7c91d2fc613f16ffda9701eeda6f/rapidocr-3.9.2-py3-none-any.whl"
    sha256 "04d6b8d151f823d930bd91910555f57bea897c0c44fa6794267b94cf9c1ef9a0"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/aa/2a/9618a122aeb2a169a28b03889a2995fe297588964333d4a7d67bdf46e147/rpds_py-2026.6.3.tar.gz"
    sha256 "1cebd1337c242e4ec2293e541f712b2da849b29f48f0c293684b71c0632625d4"
  end

  resource "shapely" do
    url "https://files.pythonhosted.org/packages/4d/bc/0989043118a27cccb4e906a46b7565ce36ca7b57f5a18b78f4f1b0f72d9d/shapely-2.1.2.tar.gz"
    sha256 "2ed4ecb28320a433db18a5bf029986aa8afcfd740745e78847e330d5d94922a9"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/69/99/a6ca3beb3ccacb41fb3321d8a60e5566f9e6467601ef8eba6a17e1b89778/soupsieve-2.9.2.tar.gz"
    sha256 "4a55d8cf158a9c2e587fa4922f1bbb91d68ac829e2d6f25403a85747c71daf74"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/f8/00/b42a44342a054d58cb1115d7c8aa9cb4290dd9442f9c1b91a4b8173dba22/sse_starlette-3.4.8.tar.gz"
    sha256 "ed89ffbb75cbf78a5fe2f2109cd584792ee7f9dfac96f791db546df8f15f3f9c"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/b5/b4/205b0d5241d934e8add0c38aa924c4f9fb7330834ff11e5444db964ec3f9/starlette-1.6.0.tar.gz"
    sha256 "d4e3ac5e546444960c710297a3c9fc3f7ebae1b7e963f3d36173b49da535be9b"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/c1/60/21f715d9faba5f5407ff759472ade058ec4a507ad62bcea47cb847239a73/tokenizers-0.23.1.tar.gz"
    sha256 "1feeeadf865a7915adc25445dea30e9933e593c31bb96c277cee36de227c8bfa"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/21/3b/6c24bec5be5e743ffd99576daa5cc077722fc7d5bbc00bd133fa0c698dc6/tqdm-4.70.0.tar.gz"
    sha256 "55b0b0dbd97462d06ebee91e4dac24ed4d4702be82b24f07e6c1d27e08cea220"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/f7/03/5600b84aff2e6c4fe80cfebb4063fe2f50299521befe5f6092ab8c082f4a/tree_sitter-0.26.0.tar.gz"
    sha256 "b40c219edccc4564530c96f8f1556f6202b37cda964d1cbd7bd2b7e68b40a245"
  end

  resource "tree-sitter-embedded-template" do
    url "https://files.pythonhosted.org/packages/fd/a7/77729fefab8b1b5690cfc54328f2f629d1c076d16daf32c96ba39d3a3a3a/tree_sitter_embedded_template-0.25.0.tar.gz"
    sha256 "7d72d5e8a1d1d501a7c90e841b51f1449a90cc240be050e4fb85c22dab991d50"
  end

  resource "tree-sitter-language-pack" do
    url "https://files.pythonhosted.org/packages/c1/83/d1bc738d6f253f415ee54a8afb99640f47028871436f53f2af637c392c4f/tree_sitter_language_pack-0.13.0.tar.gz"
    sha256 "032034c5e27b1f6e00730b9e7c2dbc8203b4700d0c681fd019d6defcf61183ec"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/ae/40/4a3db7990d1f62a53182aa96eaef57aeb2886a27f90a195bc66713565d31/typer-0.27.1.tar.gz"
    sha256 "a79bef8469a79c45498e7b814ecf8d603cc7644e9acbd9e19cac0334240b18df"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/a3/26/b09b8010994eccc3c09092e6b34058f36a460eea2d4c3e8b910c695975a0/typing_inspection-0.4.4.tar.gz"
    sha256 "547274fa6b0a561ccf549cc9524b999a578e737d015d8709d021f9d0d13bea47"
  end

  resource "ultimate-sitemap-parser" do
    url "https://files.pythonhosted.org/packages/c3/95/4b4bfd9bc572fdfd5c0ff70c85cd1b220181aaa6eb7cc70a0d2255444c10/ultimate_sitemap_parser-1.8.1.tar.gz"
    sha256 "6cf5ae0cfd83a2af5650402fc0ec462c83ac7558ef781fba9c012d1db123344f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/f2/0f/3f86e61397dd33bf2ccf28188c40db6a740658aeebbbf6e7dbc101a1f487/uvicorn-0.52.4.tar.gz"
    sha256 "73acfee47a0b133c5de13d219492d62d8a31e935f4fe6e41a232451a15379f86"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/db/7d/7f3d619e951c88ed75c6037b246ddcf2d322812ee8ea189be89511721d54/watchdog-6.0.0.tar.gz"
    sha256 "9ddf7c82fda3ae8e24decda1338ede66e1c99883db93711d8fb941eaa2d8c282"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/f7/96/e01084f83a64bcb3a27994bd0cb0db68ff29d9c6707fae37ec19b18ba990/websockets-17.0.1.tar.gz"
    sha256 "5baa9bc0dfbae8c507e51c8cf1b6d4628086f7a87bbd3a9952bd5f035451f1cc"
  end

  resource "xlsxwriter" do
    url "https://files.pythonhosted.org/packages/46/2c/c06ef49dc36e7954e55b802a8b231770d286a9758b3d936bd1e04ce5ba88/xlsxwriter-3.2.9.tar.gz"
    sha256 "254b1c37a368c444eac6e2f867405cc9e461b0ed97a3233b2ac1e574efb4140c"
  end

  def install
    # virtualenv_install_with_resources stages every resource and pip-installs
    # it, but its wheel detection only recognizes the universal "py3-none-any"
    # naming pattern -- lancedb/onnxruntime/pymupdf are platform wheels
    # (cp310-abi3-*.whl, cp313-cp313-*.whl), so the automatic path hands pip a
    # bare staged directory with no setup.py/pyproject.toml and fails. Install
    # everything else the normal way, then pip-install these wheel files
    # directly into the same venv.
    # hf-xet (transitive, via huggingface-hub) vendors aws-lc-sys, whose
    # jitterentropy-base.c hard-refuses to build if any -O flag other than
    # -O0 is seen anywhere on the command line, including the crate's own
    # cc-rs-derived default -- neither reordering nor clearing CFLAGS fixed
    # it (upstream aws-lc-sys/cc-rs issue, not a Homebrew environment one).
    # hf-xet only accelerates model downloads; huggingface-hub soft-imports
    # it and falls back to plain HTTP when absent, so it's dropped rather
    # than fought. See punt-kit/patterns/homebrew-pypi-formula.md.
    # opencv-python and opencv-python-headless (full is a hard dependency of
    # rapidocr, headless is quarry's own -- both genuinely required per
    # uv.lock, not redundant) share the same opencv 5.0.0.93 source tree and
    # both fail their cmake configure against the Homebrew ffmpeg on this
    # machine: opencv's videoio module reads AVCodec fields (pix_fmts,
    # supported_framerates) that newer ffmpeg removed. quarry never does
    # video capture, so disable that module rather than pin an older ffmpeg.
    # tokenizers (pyo3 + tokio) fails to link on macOS: Py_NewRef/Py_DecRef/
    # etc. come up undefined because it isn't picking up the
    # -undefined,dynamic_lookup linker flag other pyo3 crates in this build
    # (cryptography, rpds-py, pydantic-core) get automatically. Harmless and
    # necessary for every pyo3 extension-module build on macOS, so set it
    # explicitly rather than track down why this one crate's build.rs
    # doesn't inject it itself. Linux doesn't need or want this flag.
    ENV["RUSTFLAGS"] = "-C link-arg=-undefined -C link-arg=dynamic_lookup" if OS.mac?
    venv = virtualenv_install_with_resources without: %w[
      lancedb onnxruntime pymupdf tree-sitter-c-sharp tree-sitter-yaml
      hf-xet opencv-python opencv-python-headless
    ]
    %w[lancedb onnxruntime pymupdf tree-sitter-c-sharp tree-sitter-yaml].each do |name|
      resource(name).stage { venv.pip_install Pathname.pwd.glob("*.whl").first }
    end
    %w[opencv-python opencv-python-headless].each do |name|
      resource(name).stage do
        with_env(CMAKE_ARGS: "-DWITH_FFMPEG=OFF") { venv.pip_install Pathname.pwd }
      end
    end
  end

  service do
    # quarry has no "serve" subcommand -- the daemon is a separate console-script
    # entry point, quarryd (pyproject.toml [project.scripts]).
    run [opt_bin/"quarryd", "--port", "8420"]
    keep_alive true
    log_path var/"log/quarry.log"
    error_log_path var/"log/quarry.log"
  end

  test do
    # `quarry version` prints the bare version number, not "punt-quarry X.Y.Z"
    # (see quarry.__main__:version -- _emit({"version": ver}, ver)).
    assert_match version.to_s, shell_output("#{bin}/quarry version")
  end
end

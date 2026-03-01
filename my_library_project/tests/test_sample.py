from my_library import hello, __version__

def test_hello():
    assert hello() == "Hello from my_library!"

def test_version():
    assert __version__ == "0.1.0"

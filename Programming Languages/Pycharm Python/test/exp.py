import pytest

def inc(x):
    return x + 1

def test_answer():
    assert inc(4) == 5

def add(a,b):
    return a+b

@pytest.mark.parametrize("a, b, expected", [
    (1, 2, 3),
    (0, 0, 1),
    (-1, 1, 0),
    (100, 200, 300),
])
def test_add(a, b, expected):
    assert add(a, b) == expected












































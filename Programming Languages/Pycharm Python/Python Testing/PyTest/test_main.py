from Pycharm.AI.main import add
from Pycharm.AI.main import divide
import pytest

def test_add():
    assert add(1,3) == 4
    assert add(0,0) == 0
def test_divide():
    assert divide(1,2) == 2
    assert divide(-1,5) == -5
    with pytest.raises(ValueError,match="Cannot be divided by 0"):
        divide(0,10)

    



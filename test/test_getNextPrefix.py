import unittest
import sys
sys.path.append('.')
import get_next_prefix


class TestGetNextPrefix(unittest.TestCase):
    def test_no_args(self):
        prefix = get_next_prefix.getNextPrefix()
        self.assertEquals('a', prefix)

    def test_a_to_b(self):
        prefix = get_next_prefix.getNextPrefix('a')
        self.assertEquals('b', prefix)

    def test_y_to_z(self):
        prefix = get_next_prefix.getNextPrefix('y')
        self.assertEquals('z', prefix)

    def test_last_letter(self):
        prefix = get_next_prefix.getNextPrefix('z')
        self.assertEquals('aa', prefix)

    def test_much_farther_letter(self):
        # y gets turned to z
        prefix = get_next_prefix.getNextPrefix('faraway')
        self.assertEquals('farawaz', prefix)

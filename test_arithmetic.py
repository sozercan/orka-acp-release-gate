import unittest

from arithmetic import add, multiply


class ArithmeticTests(unittest.TestCase):
    def test_add(self):
        self.assertEqual(add(2, 3), 5)

    def test_multiply_positive(self):
        self.assertEqual(multiply(2, 3), 6)

    def test_multiply_negative(self):
        self.assertEqual(multiply(-2, 3), -6)

    def test_multiply_zero(self):
        self.assertEqual(multiply(0, 3), 0)


if __name__ == "__main__":
    unittest.main()

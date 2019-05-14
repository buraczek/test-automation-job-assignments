from __future__ import division
import unittest


class ExamplePythonLibrary(object):
    """
    Example Python library for RobotFramework.

    Attributes:
        _class_variable (str, int): Variable passed to __init__
    """

    _class_variable = None

    def __init__(self, some_arg):
        self._class_variable = some_arg

    def get_var(self):
        """
        Logs and returns variable

        :return: str, int
        """
        print('You did pass: {} to {}'.format(str(self._class_variable), self.__class__.__name__))
        return self._class_variable

    @staticmethod
    def better_evaluate(expression):
        """
        Better than standard RobotFramework eval because You can use 'from __future__ import division'

        :return: str, int
        """
        return eval(expression)


class ExamplePythonLibraryTest(unittest.TestCase):
    def test_1(self):
        instance = ExamplePythonLibrary('a')
        assert instance.get_var(), 'a'

    def test_2(self):
        instance = ExamplePythonLibrary(1)
        assert instance.get_var(), 1

    def test_3(self):
        instance = ExamplePythonLibrary(None)
        assert instance.better_eval('3/2'), 1.5

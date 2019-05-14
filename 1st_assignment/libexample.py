import unittest


class MyExampleLibrary():
    def __init__(self):
        pass

    def check_presence_in_list(self, items, *args):
        """
        Checks if tuple of args is present in list as a item and returns first encountered index if successful

        Args:

        items (list): list to search in
        *args: items to search for

        Returns:

        index (int) if item is found, (None) otherwise
        """

        print args
        print items

        if args in items:
            return items.index(args)
        else:
            return None


class MyExampleLibraryTest(unittest.TestCase):
    def test_1(self):
        a = MyExampleLibrary()
        assert a.check_presence_in_list([('William', 'Adama'), ('Gaius', 'Baltar')], 'William', 'Adama') is 0, 'Error'

    def test_2(self):
        a = MyExampleLibrary()
        assert a.check_presence_in_list([('William', 'Adama'), ('Gaius', 'Baltar')], 'William',
                                        'Baltar') is None, 'Error'

    def test_3(self):
        a = MyExampleLibrary()
        assert a.check_presence_in_list([('William', 'Adama'), ('Gaius', 'Baltar')], 'Kara', 'Thrace') is None, 'Error'


if __name__ == '__main__':
    unittest.main()

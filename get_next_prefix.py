import string


def getNextPrefix(aStr = ''):
    # validate input
    if len(aStr.strip()) == 0:
        return 'a'

    letters = string.ascii_lowercase

    index = len(aStr) - 1
    if aStr[index] != 'z':
        char = aStr[index]
        newChar = letters[letters.find(char) + 1]
        aStr = aStr[:-1] + newChar
    else:
        aStr = getNextPrefix(aStr[:-1]) + 'a'

    return aStr

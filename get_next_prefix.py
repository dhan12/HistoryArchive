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


def getPrefixFromDate(yyyymmdd):
    '''Get a alpha numeric code from the date string.

    The code will be one letter to represent the month, 
    followed by the day of the month.'''

    # Use easy to read letters
    month_letters = 'fghjkmnquvxz'

    mon = int(yyyymmdd[4:6])
    day = yyyymmdd[6:8]
    return month_letters[mon-1] + day

#  TODO


- save lastEditedCell because it should show calculations if you click off it and click back on it
- numpad: button borders when tapped
- make animations: cell animations when tapped, when no more numbers in a text field, when currency rates did update

- country names property on Currency for search
- refactor: custom colors as an extension?

- make all left and right anchors leading and trailing?
- add sounds

- have the ability to add and remove rows? max 8, min 2 - 4?
- select last selected cell instead of first cell. if no last cellected, select first cell

- handle Bitcoin: round up to more than 2 after comma


// when switching a currency, update rates
// NO, I should save the updated rates in UserDefaults every time I update them and then

// 3 locations for rates:
// 1. default rates in Constants: available always (when no internet and no new rates have been pulled from the API)
// 2. UserDefaults: available if user pulled rates at least once from the API) - re-saved to UserDefaults if date of pulled rates is newer than a date of saved rates
// 3. in memory: used most often; available if user has access to internet and was able to pull the latest rates from the API; when successfully pulled, save to "rates" property and save to UserDefaults

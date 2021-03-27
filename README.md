# Planets
A small app to display the Planets list from Star Wars

## Current Implementation
The app uses MVVM pattern to fetch the first page of the [Planets](https://swapi.dev/api/planets/) and display the contents in a customized Table View.

The following actions are added:
- Pull to Refresh
- Sort
  - Name
  - Created Date
  - Diameter
  - Population
- Filter (based on few Terrains)
- Refresh data at each launch based on the Etag header value

The app uses CoreData for storing the fetched items locally for offline viewing and API calls are made using the default URLSession calls. 
Unit tests have been added for the non-UI code.

##### Note: This was developed using Xcode 12.4

## Future Enhancements
- Pagination of the various planets and their details (based on the next value in the API)
- Relationships between Planets, Residents, Films, Starships, Vehicles, Species
- Dynamic Sort UI based on the various available params (Ascending and Descending)
- Dynamic Filter UI based on the available params
- Delete functionality
- Detailed UI about the Planet, Person and Film
- Make the app more secure 
  - Handle jail break detection and don't allow the app to be run if jailbroken
  - Add encryption to the local storage (RealmDB has support for encryption. Can be used)
- PromiseKit can be used to make all async calls more readable and maintainable
- More sophisticated Toasters and HUDs can be included
- UI Automation to test the ViewControllers' implementation

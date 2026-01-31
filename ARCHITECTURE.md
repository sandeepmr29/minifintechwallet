
## Layer Responsibilities
- **UI:** Renders and reacts to states
- **BLoC:** Manages events and state transitions
- **UseCases:** Encodes business rules
- **Repository:** Abstracts data operations
- **DataSources:** Handles actual data storage/retrieval

## Dependency Direction
Dependencies flow inward:
UI → Bloc → UseCase → Repository → DataSource

## State Management Strategy
We use the BLoC pattern to handle state transitions, with events driving state and explicit states for loading, success, and errors.

## Offline & Sync Design
The app follows an offline-first approach: local storage shows immediate data and sync with backend is handled in the background.






### Summary:
The Recipes app is a SwiftUI-based iOS application that fetches a list of recipes from a remote JSON endpoint, displays them in a scrollable list, and allows users to view details and thumbnail images efficiently. Key features include:

- Async data loading with Combine & async/await

- In-memory and disk image caching

- Modular networking layer using protocol-oriented design

- Unit test coverage for networking, image cache, and view models

<img height="500" src=https://github.com/user-attachments/assets/413d78c7-17db-4ef7-9945-4606b4e5a3b4>
<img height="500" src=https://github.com/user-attachments/assets/af441af6-bc6a-4f09-a6a9-8e13618d1d0c>
<img height="500" src=https://github.com/user-attachments/assets/6e2f1ac5-2dfa-4c9e-a098-ddc82b44f954>

### Focus Areas
I prioritized the following areas:

- Clean architecture (separation of concerns between networking, UI, caching)

- Image caching with both memory and disk support

- Testability using dependency injection and mocks

- SwiftUI best practices including use of @MainActor, @Published, and ObservableObject

These were chosen to reflect real-world app scalability, performance optimization, and code maintainability.

### Time Spent
~5–6 hours total, spread over the week:

- Day 1–2: Setup project, networking layer, and basic UI (~2 hrs)

- Day 3–4: Implement image caching (memory + disk) (~1.5 hrs)

- Day 5: Unit tests for network layer and caching (~1 hr)

- Day 6: View model, image loading, and test polishing (~1 hr)

- Day 7: Final touches, README, and cleanup (~0.5 hr)

### Trade-offs and Decisions
- Disk image caching was implemented with a background queue, but in tests, I had to add sync logic or delays to validate disk persistence correctly.

- Used system images (SF Symbols) in tests for simplicity, instead of embedding test assets.

- Didn't implement pagination or offline mode, to stay focused on core architecture.

- Limited visual customizations to spend more time on testability and clean code separation

### Weakest Part of the Project
- Image cache disk tests needed artificial delay to simulate I/O timing, which isn’t ideal

- Minimal UI polish—focused more on architecture than visual detail

- No integration/UI tests were added due to time constraints

### Additional Information
- Built using SwiftUI, @MainActor, ObservableObject, and @Published for state management

- Networking is abstracted using a Request protocol and a NetworkClient with async/await

- Disk caching is handled with NSCache and background file writes for performance

- Dependency injection is used throughout to improve testability and flexibility

- Tests are included for the network layer, image cache, and image loader

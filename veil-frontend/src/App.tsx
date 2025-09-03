import { BrowserRouter, Routes, Route } from "react-router-dom";
import LandingPage from "./pages/LandingPage";
import Chat from "./pages/Chat";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<LandingPage />} />
        <Route path="/chat" element={<Chat />} />
        {/* Future routes */}
        {/* <Route path="/app" element={<MainApp />} /> */}
      </Routes>
    </BrowserRouter>
  );
}

export default App;

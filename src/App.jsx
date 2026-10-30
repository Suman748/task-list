import { BrowserRouter, Route, Routes } from "react-router-dom";
import { TaskProvider } from "./context/TaskContext";
import TaskList from "./pages/TaskList";
import TaskForm from "./pages/TaskForm";

export default function App() {
  return (
    <TaskProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<TaskList />} />
          <Route path="/tasks/new" element={<TaskForm />} />
          <Route path="/tasks/:id/edit" element={<TaskForm />} />
          <Route path="*" element={<p>Page not found</p>} />
        </Routes>
      </BrowserRouter>
    </TaskProvider>
  );
}

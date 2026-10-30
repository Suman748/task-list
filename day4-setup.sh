#!/usr/bin/env bash
# Day 4: Add task form, routing and client validation
# Run from the ROOT of your Day 3 React (Vite) project:  bash day4-setup.sh
set -e

[ -f package.json ] || { echo "Run this from your project root (package.json not found)."; exit 1; }

# 1. Branch + backup
git checkout -b day4-task-form-routing 2>/dev/null || git checkout day4-task-form-routing
[ -f src/App.jsx ] && cp src/App.jsx src/App.day3.backup.jsx

# 2. Install router
npm install react-router-dom

mkdir -p src/data src/context src/pages src/utils

# 3. Mock data (only created if you don't already have it)
if [ ! -f src/data/mockTasks.js ]; then
cat > src/data/mockTasks.js << 'EOF'
const mockTasks = [
  { id: 1, title: "Set up project", description: "Create the React app", status: "done", dueDate: "2026-11-02" },
  { id: 2, title: "Build task list", description: "Render tasks from mock data", status: "done", dueDate: "2026-11-03" },
  { id: 3, title: "Add task form", description: "Create and edit screens", status: "in-progress", dueDate: "2026-11-04" },
];
export default mockTasks;
EOF
fi

# 4. Validation
cat > src/utils/validation.js << 'EOF'
export const STATUSES = ["todo", "in-progress", "done"];

export function validateTask(values) {
  const errors = {};
  const title = values.title.trim();

  if (!title) errors.title = "Title is required";
  else if (title.length < 3) errors.title = "Title must be at least 3 characters";
  else if (title.length > 60) errors.title = "Title must be 60 characters or fewer";

  if (values.description.length > 200) errors.description = "Description must be 200 characters or fewer";
  if (!values.dueDate) errors.dueDate = "Due date is required";
  if (!STATUSES.includes(values.status)) errors.status = "Please choose a status";

  return errors;
}
EOF

# 5. State (mock data lives in memory)
cat > src/context/TaskContext.jsx << 'EOF'
import { createContext, useContext, useState } from "react";
import initialTasks from "../data/mockTasks";

const TaskContext = createContext(null);

export function TaskProvider({ children }) {
  const [tasks, setTasks] = useState(initialTasks);

  const addTask = (task) =>
    setTasks((prev) => [...prev, { ...task, id: Date.now() }]);

  const updateTask = (id, updates) =>
    setTasks((prev) => prev.map((t) => (t.id === id ? { ...t, ...updates } : t)));

  return (
    <TaskContext.Provider value={{ tasks, addTask, updateTask }}>
      {children}
    </TaskContext.Provider>
  );
}

export const useTasks = () => useContext(TaskContext);
EOF

# 6. List page
cat > src/pages/TaskList.jsx << 'EOF'
import { Link } from "react-router-dom";
import { useTasks } from "../context/TaskContext";

export default function TaskList() {
  const { tasks } = useTasks();
  return (
    <div>
      <h1>Tasks</h1>
      <Link to="/tasks/new">+ New task</Link>
      <ul>
        {tasks.map((t) => (
          <li key={t.id}>
            <strong>{t.title}</strong> — {t.status} — due {t.dueDate}{" "}
            <Link to={"/tasks/" + t.id + "/edit"}>Edit</Link>
          </li>
        ))}
      </ul>
    </div>
  );
}
EOF

# 7. Create / edit form
cat > src/pages/TaskForm.jsx << 'EOF'
import { useState } from "react";
import { Link, useNavigate, useParams } from "react-router-dom";
import { useTasks } from "../context/TaskContext";
import { STATUSES, validateTask } from "../utils/validation";

const empty = { title: "", description: "", status: "todo", dueDate: "" };

export default function TaskForm() {
  const { id } = useParams();
  const navigate = useNavigate();
  const { tasks, addTask, updateTask } = useTasks();

  const existing = id ? tasks.find((t) => String(t.id) === id) : null;
  const [values, setValues] = useState(existing ? { ...existing } : empty);
  const [errors, setErrors] = useState({});

  if (id && !existing) {
    return (
      <div>
        <p>Task not found.</p>
        <Link to="/">Back to list</Link>
      </div>
    );
  }

  const handleChange = (e) => {
    const { name, value } = e.target;
    setValues((v) => ({ ...v, [name]: value }));
    setErrors((er) => ({ ...er, [name]: undefined }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    const found = validateTask(values);
    setErrors(found);
    if (Object.keys(found).length > 0) return;

    const clean = { ...values, title: values.title.trim() };
    if (existing) updateTask(existing.id, clean);
    else addTask(clean);
    navigate("/");
  };

  return (
    <form onSubmit={handleSubmit} noValidate>
      <h1>{existing ? "Edit task" : "New task"}</h1>

      <label>Title
        <input name="title" value={values.title} onChange={handleChange} />
      </label>
      {errors.title && <p role="alert" style={{ color: "crimson" }}>{errors.title}</p>}

      <label>Description
        <textarea name="description" value={values.description} onChange={handleChange} />
      </label>
      {errors.description && <p role="alert" style={{ color: "crimson" }}>{errors.description}</p>}

      <label>Status
        <select name="status" value={values.status} onChange={handleChange}>
          {STATUSES.map((s) => <option key={s} value={s}>{s}</option>)}
        </select>
      </label>
      {errors.status && <p role="alert" style={{ color: "crimson" }}>{errors.status}</p>}

      <label>Due date
        <input type="date" name="dueDate" value={values.dueDate} onChange={handleChange} />
      </label>
      {errors.dueDate && <p role="alert" style={{ color: "crimson" }}>{errors.dueDate}</p>}

      <div>
        <button type="submit">{existing ? "Save changes" : "Create task"}</button>{" "}
        <Link to="/">Cancel</Link>
      </div>
    </form>
  );
}
EOF

# 8. Routing
cat > src/App.jsx << 'EOF'
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
EOF

# 9. Commit
git add -A
git commit -m "Day 4: add task form, routing and client validation"

echo ""
echo "Done. Next:"
echo "  npm run dev        # test create/edit + validation in the browser"
echo "  git push -u origin day4-task-form-routing   # then open a PR and paste the link in the tracker"

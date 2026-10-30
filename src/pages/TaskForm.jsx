import "./TaskForm.css";
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

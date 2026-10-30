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

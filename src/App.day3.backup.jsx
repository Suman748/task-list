import { useMemo, useState } from 'react';
import TaskList from './TaskList.jsx';
import { mockTasks, STATUSES } from './mockTasks.js';

export default function App() {
  const [tasks, setTasks] = useState(mockTasks);
  const [query, setQuery] = useState('');
  const [filter, setFilter] = useState('All');

  const visible = useMemo(
    () =>
      tasks.filter(
        (t) =>
          (filter === 'All' || t.status === filter) &&
          t.title.toLowerCase().includes(query.toLowerCase())
      ),
    [tasks, query, filter]
  );

  const updateStatus = (id, status) =>
    setTasks((prev) => prev.map((t) => (t.id === id ? { ...t, status } : t)));

  return (
    <main className="container">
      <h1>Task List</h1>
      <div className="controls">
        <input
          type="search"
          placeholder="Search tasks..."
          value={query}
          onChange={(e) => setQuery(e.target.value)}
        />
        <select value={filter} onChange={(e) => setFilter(e.target.value)}>
          <option>All</option>
          {STATUSES.map((s) => <option key={s}>{s}</option>)}
        </select>
      </div>
      <p className="count">{visible.length} of {tasks.length} tasks</p>
      <TaskList tasks={visible} onStatusChange={updateStatus} />
    </main>
  );
}

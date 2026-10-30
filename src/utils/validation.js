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

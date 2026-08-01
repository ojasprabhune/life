ALTER TABLE logs DROP CONSTRAINT logs_parsed_type_check;
ALTER TABLE logs ADD CONSTRAINT logs_parsed_type_check
    CHECK (parsed_type IN ('nutrition', 'person', 'album', 'song', 'workout',
                           'learning', 'place', 'trip', 'sleep', 'task'));

CREATE TABLE tasks (
    id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    title          text NOT NULL,
    category       text NOT NULL,
    due_date       date,
    effort_minutes int,
    status         text NOT NULL DEFAULT 'not_started'
                   CHECK (status IN ('not_started', 'in_progress', 'done')),
    is_exam        boolean NOT NULL DEFAULT false,
    note           text,
    created_at     timestamptz NOT NULL DEFAULT now(),
    completed_at   timestamptz,
    archived_at    timestamptz
);

CREATE INDEX tasks_due_date_idx ON tasks (due_date) WHERE archived_at IS NULL;
CREATE INDEX tasks_status_idx ON tasks (status) WHERE archived_at IS NULL;

CREATE TABLE task_checkpoints (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id     uuid NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
    offset_days int NOT NULL,
    due_date    date NOT NULL,
    status      text NOT NULL DEFAULT 'todo' CHECK (status IN ('todo', 'done')),
    created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX task_checkpoints_due_date_idx ON task_checkpoints (due_date);

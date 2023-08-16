export default class Task {
    public id: number;
    public userId: number;
    public categoryId: number | null;
    public name: string;
    public description: string | null;
    public creationDate: string;
    public dueDate: string | null;
    public completionDate: string | null;

    constructor(id: number, userId: number, categoryId: number | null,
        name: string, description: string | null, creationDate: string,
        dueDate: string | null, completionDate: string | null) {
        this.id = id;
        this.userId = userId;
        this.categoryId = categoryId;
        this.name = name;
        this.description = description;
        this.creationDate = creationDate;
        this.dueDate = dueDate;
        this.completionDate = completionDate;
    }

    /**
     * Create a task object from a database row.
     */
    public static fromRow(row: any): Task {
        return new Task(row.id, row.user_id, row.category_id, row.name,
            row.description, row.creation_date, row.due_date, row.completion_date);
    }
}
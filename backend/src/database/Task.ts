export default class Task {
  public id: number;
  public userId: string;
  public categoryId: number | null;
  public name: string;
  public description: string | null;
  public creationDate: string;
  public dueDate: string | null;
  public completionDate: string | null;

  constructor(
    id: number,
    userId: string,
    categoryId: number | null,
    name: string,
    description: string | null,
    creationDate: string,
    dueDate: string | null,
    completionDate: string | null,
  ) {
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
    return new Task(
      row.id as number,
      row.user_id as string,
      row.category_id as number | null,
      row.name as string,
      row.description as string | null,
      row.creation_date as string,
      row.due_date as string | null,
      row.completion_date as string | null,
    );
  }

  public toString(): string {
    return `Task [id=${this.id}, userId=${this.userId}, categoryId=${this.categoryId}, name=${this.name}, description=${this.description}, creationDate=${this.creationDate}, dueDate=${this.dueDate}, completionDate=${this.completionDate}]`;
  }

  public toJSON(): any {
    return {
      id: this.id,
      user_id: this.userId,
      category_id: this.categoryId,
      name: this.name,
      description: this.description,
      creation_date: this.creationDate,
      due_date: this.dueDate,
      completion_date: this.completionDate,
    };
  }
}

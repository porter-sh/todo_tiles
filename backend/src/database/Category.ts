export default class Category {
  public id: number;
  public userId: string;
  public name: string;
  public description: string | null;
  public displayColor: string | null;

  constructor(
    id: number,
    userId: string,
    name: string,
    description: string | null,
    displayColor: string | null,
  ) {
    this.id = id;
    this.userId = userId;
    this.name = name;
    this.description = description;
    this.displayColor = displayColor;
  }

  /**
   * Create a category object from a database row.
   */
  public static fromRow(row: any): Category {
    return new Category(
      row.id as number,
      row.user_id as string,
      row.name as string,
      row.description as string | null,
      row.display_color as string | null,
    );
  }

  public toString(): string {
    return `Category [id=${this.id}, userId=${this.userId}, name=${this.name}, description=${this.description}, displayColor=${this.displayColor}]`;
  }

  public toJSON(): any {
    return {
      id: this.id,
      user_id: this.userId,
      name: this.name,
      description: this.description,
      display_color: this.displayColor,
    };
  }
}

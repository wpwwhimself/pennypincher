interface Account {
  id: number,
  name: string,
  description?: string,
  color: string,
  created_at: Date,
  updated_at: Date, 
}

interface Category {
  id: number,
  name: string,
  description?: string,
  color: string,
  parent_id?: number,
  parent?: Category,
  subcategories?: Category[],
  created_at: Date,
  updated_at: Date, 
}

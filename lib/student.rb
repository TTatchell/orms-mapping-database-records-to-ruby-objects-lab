require "pry"

class Student
  attr_accessor :id, :name, :grade

  def initialize(id = nil, name = nil, grade = nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.new_from_db(row) #row = [id, name, grade]
    # create a new Student object given a row from the database
    student = Student.new(row[0], row[1], row[2])
  end

  def self.all
    sql = <<-SQL
    SELECT * FROM students
    SQL
    rows = DB[:conn].execute(sql)
    rows.collect do |row|
      Student.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students
    WHERE name = ?
    LIMIT 1
    SQL
    row = DB[:conn].execute(sql, name).flatten
    student = Student.new_from_db(row)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = ?
    SQL
    rows = DB[:conn].execute(sql, 9)
    # rows.collect do |row|
    #   Student.new_from_db(row)
    # end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade < ?
    SQL
    rows = DB[:conn].execute(sql, 12)
    rows.collect do |row|
      Student.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(n)
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = ?
    LIMIT ?
    SQL
    rows = DB[:conn].execute(sql, 10, n)
    rows.collect do |row|
      Student.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 10
    LIMIT 1
    SQL
    row = DB[:conn].execute(sql).flatten
    student = Student.new_from_db(row)
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = ?
    SQL
    rows = DB[:conn].execute(sql, grade)
    rows.collect do |row|
      Student.new_from_db(row)
    end
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end

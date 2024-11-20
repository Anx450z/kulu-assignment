# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_11_18_184458) do
  create_table "comments", force: :cascade do |t|
    t.string "body"
    t.json "likes", default: []
    t.integer "user_id", null: false
    t.integer "task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_comments_on_task_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "invites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "status", default: 0
    t.integer "role", default: 0
    t.string "email", null: false
    t.integer "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email", "project_id"], name: "index_invites_on_email_and_project_id", unique: true
    t.index ["project_id"], name: "index_invites_on_project_id"
    t.index ["user_id"], name: "index_invites_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.integer "owner_id", null: false
    t.string "title", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_projects_on_owner_id"
  end

  create_table "projects_users", id: false, force: :cascade do |t|
    t.integer "project_id"
    t.integer "user_id"
    t.index ["project_id", "user_id"], name: "index_projects_users_on_project_id_and_user_id", unique: true
    t.index ["project_id"], name: "index_projects_users_on_project_id"
    t.index ["user_id"], name: "index_projects_users_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title", limit: 255, null: false
    t.text "description"
    t.integer "project_id", null: false
    t.datetime "completed_at"
    t.datetime "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id", "completed_at"], name: "index_tasks_on_project_id_and_completed_at"
    t.index ["project_id"], name: "index_tasks_on_project_id"
  end

  create_table "tasks_users", force: :cascade do |t|
    t.integer "task_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id", "user_id"], name: "index_tasks_users_on_task_id_and_user_id", unique: true
    t.index ["task_id"], name: "index_tasks_users_on_task_id"
    t.index ["user_id", "task_id"], name: "index_tasks_users_on_user_id_and_task_id"
    t.index ["user_id"], name: "index_tasks_users_on_user_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.integer "user_id"
    t.string "content", default: "", null: false
    t.integer "active_status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content"], name: "index_tokens_on_content", unique: true
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "comments", "tasks"
  add_foreign_key "comments", "users"
  add_foreign_key "invites", "projects"
  add_foreign_key "invites", "users"
  add_foreign_key "projects", "users", column: "owner_id"
  add_foreign_key "tasks", "projects"
  add_foreign_key "tasks_users", "tasks"
  add_foreign_key "tasks_users", "users"
  add_foreign_key "tokens", "users"
end

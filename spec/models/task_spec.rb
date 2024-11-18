require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'factories' do
    context 'default factory' do
      subject { build(:task) }
      it { is_expected.to be_valid }
    end

    context 'completed task' do
      subject { build(:task, :completed) }
      it { is_expected.to be_valid }
      it { expect(subject.completed_at).to be_present }
    end

    context 'overdue task' do
      subject { build(:task, :overdue) }
      it { is_expected.to be_valid }
      it { expect(subject.due_date).to be < Time.current }
    end
  end

  describe 'associations' do
    it { should belong_to(:project) }
    it { should have_and_belong_to_many(:users) }
  end

  describe 'validations' do
    subject { build(:task) }

    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(255) }
    it { should validate_length_of(:description).is_at_most(1000) }
  end

  describe 'scopes' do
    let!(:completed_task) { create(:task, :completed) }
    let!(:active_task) { create(:task) }

    describe '.active' do
      it 'returns only active tasks' do
        expect(Task.active).to include(active_task)
        expect(Task.active).not_to include(completed_task)
      end
    end

    describe '.completed' do
      it 'returns only completed tasks' do
        expect(Task.completed).to include(completed_task)
        expect(Task.completed).not_to include(active_task)
      end
    end
  end

  describe 'instance methods' do
    describe '#ensure_unique_project_user_combination' do
      let(:project) { create(:project) }
      let(:user) { create(:user) }
      let!(:existing_task) { create(:task, project: project, users: [user]) }

      it 'allows creating task for different user in same project' do
        new_task = build(:task, project: project)
        new_task.users << create(:user)

        expect { new_task.save! }.not_to raise_error
      end
    end
  end

  describe 'callbacks' do
    let(:project) { create(:project) }
    let(:task) { create(:task, project: project) }

    it 'touches associated project on save' do
      expect { task.touch }.to change { project.reload.updated_at }
    end
  end

  describe 'business logic' do
    describe 'completion status' do
      let(:task) { create(:task) }

      it 'is not completed by default' do
        expect(task.completed_at).to be_nil
      end

      it 'can be marked as completed' do
        task.update(completed_at: Time.current)
        expect(task.completed_at).to be_present
      end
    end

    describe 'due date handling' do
      let(:task) { create(:task, :due_today) }

      context 'when overdue' do
        let(:task) { create(:task, :overdue) }

        it 'identifies overdue tasks' do
          expect(task.due_date).to be < Time.current
        end
      end
    end

    describe 'user assignment' do
      let(:task) { create(:task) }
      let(:new_user) { create(:user) }

      it 'can assign multiple users' do
        expect { task.users << new_user }.to change { task.users.count }.by(1)
      end
    end
  end

  describe 'edge cases' do
    let(:task) { build(:task) }

    it 'handles very long titles' do
      task.title = 'a' * 256
      expect(task).not_to be_valid
      expect(task.errors[:title]).to include('is too long (maximum is 255 characters)')
    end

    it 'handles very long descriptions' do
      task.description = 'a' * 1001
      expect(task).not_to be_valid
      expect(task.errors[:description]).to include('is too long (maximum is 1000 characters)')
    end

    it 'handles nil due dates' do
      task.due_date = nil
      expect(task).to be_valid
    end
  end
end

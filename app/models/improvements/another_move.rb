# frozen_string_literal: true

module Improvements
  # This is for Improvements like "Take a move from another playbook"
  class AnotherMove < Improvement
    def apply(hunters_improvement)
      return false if add_errors(hunters_improvement)

      hunters_improvement.hunter.moves << hunters_improvement.improvable
    end

    def add_errors(hunters_improvement)
      super(hunters_improvement)
      validate_hunter hunters_improvement
      validate_improvable hunters_improvement
      hunters_improvement.errors.present?
    end

    def validate_hunter(hunters_improvement)
      return unless hunter_has_move?(hunters_improvement.hunter, hunters_improvement.improvable)
      hunters_improvement.errors.add(:hunter, "already has move with id #{hunters_improvement.improvable.id}")
    end

    def validate_improvable(hunters_improvement)
      move = hunters_improvement.improvable
      hunters_improvement.errors.add(:improvable, 'is not a subclass of Move.') if not_a_move?(move)
      hunters_improvement.errors.add(:improvable, "is from the hunter's playbook #{playbook.name}") if move_matches_playbook?(move)
      hunters_improvement.errors.present?
    end

    def move_matches_playbook?(move)
      move?(move) && move.playbook == playbook
    end

    def not_a_move?(move)
      !move?(move)
    end

    def move?(move)
      move.class <= Move
    end

    def hunter_has_move?(hunter, move)
      hunter.moves.include? move
    end

    def improvable_options(hunter)
      Move.where.not(id: hunter.moves.select(:id)).where.not(playbook_id: playbook_id)
    end
  end
end

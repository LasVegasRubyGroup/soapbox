class Award

  # Award { topic: topic_id,
        #   user: user_id,
        #   base: 5,
        #   presenter: 3/4 votes,
        #   suggester: 1/4 votes,
        #   kudos: kudo #,
        #   bonus: 10 if 1st time
        # }
        # Reasons will be stored as a serialized hash. Likely to be
        # turned into a join-table model.
  
  attr_accessor :total_points, :suggestion_points, :presentation_points, :kudos_points
end

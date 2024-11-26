defmodule Helpdesk.Support.Ticket do
  use Ash.Resource,
    otp_app: :helpdesk,
    domain: Helpdesk.Support,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshStateMachine]

  @valid_states [:state_a, :state_b, :state_c, :state_d, :state_e]
  @closed_states [:state_c, :state_d, :state_e]

  postgres do
    table "tickets"
    repo Helpdesk.Repo
  end

  state_machine do
    initial_states(@valid_states)
    default_initial_state(:state_a)
    state_attribute(:state)

    transitions do
      transition(:*, from: :state_a, to: @valid_states)
      transition(:*, from: :state_b, to: @valid_states)
      transition(:*, from: :state_c, to: @closed_states)
      transition(:*, from: :state_d, to: @closed_states)
      transition(:*, from: :state_e, to: @closed_states)
    end
  end

  actions do
    defaults [:read]

    create :create do
      primary? true
      accept [:subject]

      argument :state, :atom, allow_nil?: false
      change transition_state(arg(:state))
    end

    update :update do
      primary? true
      accept [:subject]

      argument :state, :atom, allow_nil?: false
      change transition_state(arg(:state))
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :subject, :string, allow_nil?: false, public?: true

    attribute :state, :atom do
      constraints one_of: @valid_states
      default :state_a
      allow_nil? false
      public? true
    end

    timestamps()
  end
end

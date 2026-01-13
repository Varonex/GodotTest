using Godot;
using System;

[GlobalClass]
public partial class StateMachine : Node
{
    
    // VARIABLES.


    // Current state.
    [Export] private State _state; 
    
    // Describes whether or not the current state machine is active.
    private bool _isActive;
    [Export] public bool IsActive
    {
        get => _isActive;
        set
        {
            _isActive = value;
            
            SetProcess(value);
            SetPhysicsProcess(value);
        }
    }

    public bool HasEnded
    {
        get => _state.TransitionCount == 0;
        private set {}
    }
    
    
    // SIGNALS.


    // Fires when the machine transitioned to a new state.
    [Signal] public delegate void OnStateChangedEventHandler(State newState);
    
    
    // ENGINE.


    public override void _Ready()
    {
        _state.OnEnterState();
    }

    public override void _Process(double delta)
    {
        _state._StateProcess(delta);
        
        // State change (if needed).
        ChangeState(_state.TransitionTo());
    }

    public override void _PhysicsProcess(double delta)
    {
        _state._StatePhysicsProcess(delta);
    }
    
    
    // METHODS.


    // Changes the current state.
    public void ChangeState(State newState)
    {
        if (newState != null)
        {
            _state.OnExitState();
            newState.OnEnterState();
            
            _state = newState;
            
            EmitSignal(SignalName.OnStateChanged, newState);
        }
    }
}

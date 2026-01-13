using Godot;
using System;
using System.Linq;
using System.Collections.Generic;
using static Godot.GD;

[GlobalClass]
public partial class RPCEntity : Node
{
    public const string ADDRESS = "127.0.0.1";
    public const int PORT = 9111;
    public const int MAX_CLIENT = 2;

    private List<int> _peers = new();
    
    [Export] private Timer _timer;

    public override void _Ready()
    {
        ENetMultiplayerPeer peer = new();
        
        Multiplayer.Connect(MultiplayerApi.SignalName.PeerConnected, Callable.From<int>(_OnPeerConnected));
        Multiplayer.Connect(MultiplayerApi.SignalName.PeerDisconnected, Callable.From<int>(_OnPeerDisconnected));

        if (OS.GetCmdlineArgs().Contains("--is-server"))
            peer.CreateServer(PORT, MAX_CLIENT);
        else
            peer.CreateClient(ADDRESS, PORT);

        Multiplayer.MultiplayerPeer = peer;
        
        output($"Created peer (id = {Multiplayer.GetUniqueId()})");

        _timer.Connect(Timer.SignalName.Timeout, Callable.From(_OnTimeout));
    }

    private void _OnTimeout()
    {
        if (_peers.Count == 0)
            return;
        
        // Call both methods.
        Rpc(MethodName.RpcAll);

        if (Multiplayer.IsServer())
            Rpc(MethodName.RpcServer);
    }

    private void _OnPeerConnected(int id)
    {
        output($"A peer connected (id = {id})");
        
        if (! _peers.Contains(id))
            _peers.Add(id);
    }

    private void _OnPeerDisconnected(int id)
    {
        output($"A peer disconnected (id = {id}");
        
        _peers.Remove(id);
    }

    private void output(string msg)
    {
        string prefix = (Multiplayer.IsServer()) ? "SERVER" : "CLIENT";
        
        Print($"[{prefix} - {Multiplayer.GetUniqueId()}]: {msg}");
    }

    [Rpc(MultiplayerApi.RpcMode.AnyPeer, CallLocal = false, TransferMode = MultiplayerPeer.TransferModeEnum.UnreliableOrdered)]
    private void RpcAll() => output($"Can be called by anyone (id = {Multiplayer.GetRemoteSenderId()})");

    [Rpc(MultiplayerApi.RpcMode.Authority,  CallLocal = false, TransferMode = MultiplayerPeer.TransferModeEnum.UnreliableOrdered)]
    private void RpcServer() => output($"Can only be invoked by the server (id = {Multiplayer.GetRemoteSenderId()} = 1)");
}

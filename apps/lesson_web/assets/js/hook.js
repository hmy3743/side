let Hooks = {};
window.hooks = Hooks;
Hooks.ConnectWebRTCVideo = {
  peerConnectionMap: new Map(),
  async mounted() {
    const remoteVideos = this.el.querySelectorAll("video");
    console.log("remoteVideos", remoteVideos);
    const localStream = await navigator.mediaDevices.getUserMedia({
      video: true,
      audio: true,
    });

    for (const remoteVideo of remoteVideos) {
      console.log("remoteVideo", remoteVideo.id);
      const pc = this.createPeerConnection();

      this.peerConnectionMap.set(remoteVideo.id, pc);

      // Set local video
      for (const track of localStream.getTracks()) {
        pc.addTrack(track, localStream);
      }
      // Set remote video
      pc.ontrack = (event) => {
        remoteVideo.srcObject = event.streams[0];
        remoteVideo.play();
      };

      pc.onicecandidate = (event) => {
        console.log("send_ice_candidate", event.candidate);
        const ice_candidate = event.candidate;
        this.pushEvent("send_ice_candidate", {
          ice_candidate,
          to: remoteVideo.id,
        });
      };

      const offer = await this.createOffer(pc);
      pc.setLocalDescription(offer);

      console.log("[info] send_offer", remoteVideo.id);
      this.pushEvent("send_offer", { offer, to: remoteVideo.id });
    }

    this.handleEvent("offer_from_server", async ({ offer, from }) => {
      console.log("[info] server send offer to client", from);

      const pc = this.peerConnectionMap.get(from);

      pc.setRemoteDescription(offer);
      const answer = await pc.createAnswer();
      pc.setLocalDescription(answer);

      this.pushEvent("reply_answer", { answer, to: from });
    });

    this.handleEvent("answer_from_server", async ({ answer, from }) => {
      console.log("[info] server send answer to client", from);
      console.log("reply", answer);
      const pc = this.peerConnectionMap.get(from);

      pc.setRemoteDescription(answer);
      console.log("answer_from_server", pc);
    });

    this.handleEvent("ice_candidate_from_server", ({ ice_candidate, from }) => {
      console.log("[info] receive_ice_candidate", from);
      const pc = this.peerConnectionMap.get(from);
      pc.addIceCandidate(ice_candidate);
    });
  },

  async updated() {
    updated_videos = Array.from(this.el.querySelectorAll("video")).filter(
      (video) => !this.peerConnectionMap.has(video.id)
    );

    for (const updated_video of updated_videos) {
      const pc = this.createPeerConnection();
      this.peerConnectionMap.set(updated_video.id, pc);

      const localStream = await navigator.mediaDevices.getUserMedia({
        video: true,
        audio: true,
      });

      for (const track of localStream.getTracks()) {
        pc.addTrack(track, localStream);
      }
      pc.ontrack = (event) => {
        updated_video.srcObject = event.streams[0];
        updated_video.play();
      };

      pc.onicecandidate = (event) => {
        console.log("send_ice_candidate", event.candidate);
        if (event.candidate === null || pc.remoteDescription === null) return;

        const ice_candidate = event.candidate;
        this.pushEvent("send_ice_candidate", {
          ice_candidate,
          to: updated_video.id,
        });
      };
    }
  },

  createPeerConnection() {
    const pc = new RTCPeerConnection({
      iceServers: [
        {
          urls: ["stun:stun.1.google.com:19302"],
        },
      ],
      sdpSemantics: "unified-plan",
      iceCandidatePoolSize: 10,
    });

    pc.addEventListener("icegatheringstatechange", () =>
      console.log("icegatheringstatechange", pc.iceGatheringState)
    );
    pc.addEventListener("iceconnectionstatechange", () =>
      console.log("iceconnectionstatechange", pc.iceConnectionState)
    );
    pc.addEventListener("signalingstatechange", () =>
      console.log("signalingstatechange", pc.signalingState)
    );
    pc.addEventListener("connectionstatechange", (event) =>
      console.log("connectionstatechange", pc.connectionState, event)
    );
    pc.onicecandidateerror = (event) => {
      console.log("onicecandidateerror", event);
      if (event.errorCode === 701){
        this.pushEvent("onicecandidateerror", { event: event.errorText });
      }
    };

    return pc;
  },

  async createOffer(pc) {
    const offer = await pc.createOffer({
      offerToReceiveAudio: true,
      offerToReceiveVideo: true,
    });
    pc.setLocalDescription(offer);
    return {
      sdp: offer.sdp,
      type: offer.type,
    };
  },
};

export default Hooks;

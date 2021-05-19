const functions = require("firebase-functions");
//const { user } = require("firebase-functions/lib/providers/auth");
const admin = require('firebase-admin')
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.onNewFollower = functions.firestore.document("/followers/{userId}/userFollowers/{followerId}").onCreate((snapshot, context) => {
    colsole.log("New Follower", snapshot.data());
    const userId = context.params.userId;
    const followerId = context.params.followerId;
    const userFollowedReference = admin.firestore().collection('posts').doc(userId).collection('userPosts');
    const timelinePostsReference = admin.firestore.collection('timeline').doc(followerId).collection('timelinePosts');
    const querySnapshot = await userFollowedPostsReference.get();
    querySnapshot.forEach(snap => {
        if(snap.exists) {
            const postId = snap.id;
            const postData = snap.data();
            timelinePostsReference.snap(postId).set(postData);
        }
    })
});
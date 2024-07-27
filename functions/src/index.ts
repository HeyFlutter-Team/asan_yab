import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as express from "express";
import * as cors from "cors";
import {FieldValue} from "@google-cloud/firestore";

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  // Add your other configuration options here if needed
});
// main app
const app = express();
app.use(cors({origin: true}));

class QuickSort {
  main(arr: any[], key: string, pivot: string): any[] {
    console.log("Unsorted List:", arr);

    const sortedArray: any[] = [...arr];
    this.quickSort(sortedArray, 0, sortedArray.length - 1, key, pivot);

    console.log("Sorted List:", sortedArray);

    return sortedArray;
  }

  quickSort(arr: any[], low: number, high: number, key: string, pivot: string)
  : void {
    if (low < high) {
      const partitionIndex = this.partition(arr, low, high, key, pivot);

      // Recursively sort elements before and after the partition index
      this.quickSort(arr, low, partitionIndex - 1, key, pivot);
      this.quickSort(arr, partitionIndex + 1, high, key, pivot);
    }
  }

  partition(arr: any[], low: number, high: number, key: string, pivot: string)
  : number {
    // Choose pivot as the specified string
    const pivotValue = pivot.toLowerCase();

    let i = low - 1; // Index of the smaller element

    for (let j = low; j <= high; j++) {
      // If the current element's 'name' contains the specified string
      if (arr[j][key].toLowerCase().includes(pivotValue)) {
        i++;

        // Swap arr[i] and arr[j]
        const temp: any = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
      }
    }

    // Swap arr[i+1] and arr[high] (pivot)
    const temp: any = arr[i + 1];
    arr[i + 1] = arr[high];
    arr[high] = temp;

    return i + 1; // Return the partition index
  }
}

class BetterNaiveContainsSearch {
  static search(pivot: string, arr: any[], key: string)
  : any[] {
    const resultArray: any[] = [];

    const endIndex = Math.ceil(arr.length / 2);

    for (let i = 0; i < endIndex; i++) {
      const element = arr[i];

      if (element[key].includes(pivot)) {
        resultArray.push(element);
      }
    }

    return resultArray;
  }
}

export const SearchPlace = functions.https.onRequest(
  async (request, response) => {
    try {

      const snapshot = await admin.firestore().collection("NewPlaces").get();


      const documents: any[] = [];
      snapshot.forEach((doc: any) => {
        documents.push(doc.data());
      });


      const pivot = request.query.pivot;
      console.log("Received pivot:", pivot);

      const quickSortInstance = new QuickSort();
      const sortedList =
       quickSortInstance.main(documents, "name", pivot as string);


      const firstHalfFilteredList =
       BetterNaiveContainsSearch
         .search(pivot as string, sortedList
           .slice(0, Math.ceil(sortedList.length / 2)), "name");

      response.send({filteredList: firstHalfFilteredList});
    } catch (error) {
      console.error("Error: what happened", error);
      response.status(500).send("Internal Server Error ");
    }
  }
);
// routes
app.get("/", async (req: any, res: any)=> {
  return res.status(200).send("Hai there how you doing? ...");
});
// main databas
const db = admin.firestore();

//  create -> post()
app.put("/api/update/:uid", async (req: any, res: any)=> {
  const uid = req.params.uid;
  const followId = req.query.followId;
  try {
    const snap = await db
      .collection("User")
      .doc(uid)
      .collection("Follow")
      .doc(uid)
      .get();


    const following = snap.data()?.following || [];

    if (following.includes(followId)) {
      await db
        .collection("User")
        .doc(followId)
        .collection("Follow")
        .doc(followId)
        .update({
          followers: FieldValue.arrayRemove(uid),
        });
      const snap2 = await db
        .collection("User")
        .doc(followId)
        .collection("Follow")
        .doc(followId)
        .get();
      await db
        .collection("User")
        .doc(followId)
        .update({
          followerCount: snap2.data()!.followers.length,
          followingCount: snap2.data()!.following.length,
        });
      await db
        .collection("User")
        .doc(uid)
        .collection("Follow")
        .doc(uid)
        .update({
          following: FieldValue.arrayRemove(followId),
        });
      const snap1 = await db
        .collection("User")
        .doc(uid)
        .collection("Follow")
        .doc(uid)
        .get();
      await db
        .collection("User")
        .doc(uid)
        .update({
          followerCount: snap1.data()!.followers.length,
          followingCount: snap1.data()!.following.length,
        });
    } else {
      await db
        .collection("User")
        .doc(followId)
        .collection("Follow")
        .doc(followId)
        .update({
          followers: FieldValue.arrayUnion(uid),
        });
      const snap2 = await db
        .collection("User")
        .doc(followId)
        .collection("Follow")
        .doc(followId)
        .get();
      await db
        .collection("User")
        .doc(followId)
        .update({
          followerCount: snap2.data()!.followers.length,
          followingCount: snap2.data()!.following.length,
        });
      await db
        .collection("User")
        .doc(uid)
        .collection("Follow")
        .doc(uid)
        .update({
          following: FieldValue.arrayUnion(followId),
        });
      const snap1 = await db
        .collection("User")
        .doc(uid)
        .collection("Follow")
        .doc(uid)
        .get();
      await db
        .collection("User")
        .doc(uid)
        .update({
          followerCount: snap1.data()!.followers.length,
          followingCount: snap1.data()!.following.length,
        });
    }


    return res.send({body: "Data update"});
  } catch (error) {
    console.log(error);
    return res.status(500).send({msg: error});
  }
});
// get -> get()
// fetch - single Data from  firebase useing specific ID
app.get("/api/get/:id", async (req, res)=> {
  try {
    const reqDoc = db.collection("Follow").doc(req.params.id);
    const userDetail = await reqDoc.get();
    const response = userDetail.data();

    return res.status(200).send({data: response});
  } catch (error) {
    console.log(error);
    return res.status(500).send({status: "Faild", msg: error});
  }
});
// fetch - All Data from  firebase useing specific ID
app.get("/api/getAll", async (req, res)=> {
  try {
    const query = db.collection("Follow");
    const response: any = [];
    await query.get().then((data: any)=> {
      const docs1 = data.docs;
      docs1.map((doc: any)=> {
        const selectedItem = {
          name: doc.data().name,
          address: doc.data().address,
        };
        response.push(selectedItem);
      });
      return response;
    });
    return res.status(200).send({data: response});
  } catch (error) {
    console.log(error);
    return res.status(500).send({status: "Faild", msg: error});
  }
});
// update -> put()
app.put("/api/update/:id", async (req, res)=> {
  try {
    const reqDoc = db.collection("Follow").doc(req.params.id);
    await reqDoc.update({
      name: req.body.name,
      address: req.body.address,
    });
    res.send({body: "Data update"});
  } catch (error) {
    console.log(error);
    res.status(500).send({msg: error});
  }
});
// Deleted -> delete()
app.delete("/api/delete/:id", async (req, res)=> {
  try {
    const reqDoc = db.collection("Follow").doc(req.params.id);
    await reqDoc.delete();

    res.send({body: "Data removed"});
  } catch (error) {
    console.log(error);
    res.status(500).send({msg: error});
  }
});
// exports the api to firebase cloud functions
exports.app = functions.https.onRequest(app);

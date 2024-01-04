import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

class QuickSort {
  main(arr: any[], key: string, pivot: string): any[] {
    console.log("Unsorted List:", arr);

    this.quickSort(arr, 0, arr.length - 1, key, pivot);

    console.log("Sorted List:", arr);
    const filteredList =
    arr.filter((item) => item[key].toLowerCase().includes(pivot.toLowerCase()));
    // Return the first 8 items of the sorted list
    return filteredList;
  }

  quickSort(arr: any[], low: number, high: number, key: string, pivot: string):
   void {
    if (low < high) {
      const partitionIndex = this.partition(arr, low, high, key, pivot);

      // Recursively sort elements before and after the partition index
      this.quickSort(arr, low, partitionIndex - 1, key, pivot);
      this.quickSort(arr, partitionIndex + 1, high, key, pivot);
    }
  }

  partition(arr: any[], low: number, high: number, key: string, pivot: string):
   number {
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

export const yourFunctionName = functions.https.onRequest(
  async (request, response) => {
    try {
      // Retrieve data from Firebase collection 'Places'
      const snapshot = await admin.firestore().collection("Places").get();

      // Extract documents as an array
      const documents: any[] = [];
      snapshot.forEach((doc) => {
        documents.push(doc.data());
      });

      // Get the pivot value from the query parameter or use a default value
      const pivot = request.query.pivot;

      const quickSortInstance = new QuickSort();
      const sortedList = quickSortInstance.main(documents, "name", pivot);

      response.send({sortedList});
    } catch (error) {
      console.error("Error:", error);
      response.status(500).send("Internal Server Error");
    }
  }
);

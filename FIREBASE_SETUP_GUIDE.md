# Firebase Setup Guide for Real Estate App

## ✅ Configuration Complete!

Your app has been successfully configured with the new Firebase project: **housely-f7af5**

## 🚀 Next Steps

### 1. Enable Firestore Database

Before running the app, you need to enable Firestore in your Firebase Console:

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project: **housely-f7af5**
3. Click on **Firestore Database** in the left menu
4. Click **Create database**
5. Choose **Start in test mode** (for development)
6. Select a location (choose closest to you)
7. Click **Enable**

### 2. Update Firestore Security Rules (Important!)

For development/testing, set these rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

⚠️ **Warning**: These rules allow anyone to read/write. Only use for development!

### 3. Enable Firebase Authentication

1. In Firebase Console, go to **Authentication**
2. Click **Get started**
3. Enable these sign-in methods:
   - **Email/Password** - Click Enable and Save
   - **Google** - Click Enable, add support email, and Save

### 4. Run the App

```bash
flutter run
```

The app will start with a **Setup Firebase Data** screen.

### 5. Populate Demo Data

When the app launches:

1. You'll see the **Setup Firebase Data** screen
2. Click the **"Populate Firebase"** button
3. Wait for the process to complete (adds 10 properties + 5 locations)
4. Click **"Done - Go to App"** to start using the app

Alternatively, you can click **"Skip Setup - Go to App"** if you want to add data manually later.

## 📊 What Data Gets Added?

### Properties Collection (10 items)
- Luxury Villa Bali ($450/night)
- Modern Downtown Apartment ($2800/month)
- Cozy Beach House ($320/night)
- Mountain Cabin Retreat ($180/night)
- Urban Loft Studio ($1500/month)
- Seaside Penthouse ($650/night)
- Country Farmhouse ($2200/month)
- Downtown Condo ($220/night)
- Historic Townhouse ($3500/month)
- Desert Oasis Villa ($380/night)

Each property includes:
- Images (from Unsplash)
- Location with coordinates
- Ratings and reviews
- Agent information
- Amenities (bedrooms, bathrooms, parking)

### Top Locations Collection (5 items)
- Bali, Indonesia
- New York, USA
- Paris, France
- Tokyo, Japan
- Dubai, UAE

## 🔧 Troubleshooting

### "Permission denied" error
- Make sure you've enabled Firestore and set the security rules to test mode

### "Firebase not initialized" error
- Make sure you ran `flutterfire configure --project=housely-f7af5`
- Check that `lib/firebase_options.dart` exists and has the correct project ID

### Images not loading
- Images use Unsplash URLs and require internet connection
- Check your internet connection

### Google Sign-In not working
- Make sure you've enabled Google authentication in Firebase Console
- Add your SHA-1 certificate fingerprint for Android (see GOOGLE_SIGNIN_SETUP.md)

## 📱 Testing the App

After populating data, you can:

1. **Browse Properties**: See all 10 demo properties on the home screen
2. **View Details**: Tap any property to see full details
3. **Add to Favorites**: Tap the heart icon to favorite properties
4. **View Favorites**: Go to the Favorites tab to see favorited properties
5. **Book Properties**: Select dates and book a property
6. **Create Account**: Sign up with email or Google
7. **Edit Profile**: Update your profile information

## 🔐 Production Checklist

Before deploying to production:

- [ ] Update Firestore security rules with proper authentication
- [ ] Upload real images to Firebase Storage
- [ ] Remove test data
- [ ] Enable Firebase App Check
- [ ] Set up proper error logging
- [ ] Configure Firebase Analytics
- [ ] Test on real devices
- [ ] Add proper data validation
- [ ] Implement rate limiting

## 📝 Firebase Collections Structure

```
firestore/
├── properties/
│   ├── {propertyId}/
│   │   ├── name: string
│   │   ├── price: number
│   │   ├── duration: string
│   │   ├── location: string
│   │   ├── images: array
│   │   ├── isFav: boolean
│   │   ├── rating: number
│   │   ├── bedroom: number
│   │   ├── bathtub: number
│   │   ├── parking: number
│   │   ├── Status: string
│   │   ├── buildYear: number
│   │   ├── areaSqft: number
│   │   ├── agent: array
│   │   ├── geolocation: map
│   │   └── review: array
│   
├── toplocation/
│   ├── {locationId}/
│   │   ├── name: string
│   │   └── image: string
│   
├── users/
│   ├── {userId}/
│   │   ├── name: string
│   │   ├── email: string
│   │   ├── photoURL: string
│   │   ├── DOB: string
│   │   ├── createdAt: timestamp
│   │   └── updatedAt: timestamp
│   
└── bookings/
    ├── {bookingId}/
    │   ├── name: string
    │   ├── location: string
    │   ├── price: number
    │   ├── duration: string
    │   ├── startdate: timestamp
    │   ├── enddate: timestamp
    │   ├── status: string
    │   ├── userid: string
    │   ├── propertyid: string
    │   └── total: number
```

## 🎉 You're All Set!

Your Firebase is now configured and ready to use. Run the app and populate the demo data to start exploring!

For any issues, check the Firebase Console logs or the Flutter console output.

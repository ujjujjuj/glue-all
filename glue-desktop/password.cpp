#include <bits/stdc++.h>

using namespace std;

void func();

template <class T>
void print_v(vector<T> &v) {
    cout << "[ ";
    for (const auto &x : v) cout << x << " ";
    cout << "]" << endl;
}

int main() {
    ios_base::sync_with_stdio(0);
    cin.tie(0);
    cout.tie(0);
    int t;
    cin >> t;
    while (t--) {
        func();
    }

    return 0;
}

// #define int long long
void func() {
    int n;
    cin >> n;
    vector<int> vec(n);
    vec.resize(n);
    for (int i = 0; i < n; i++) {
        cin >> vec[i];
    }
    int combinations = (10 - n) * (9 - n) / 2;
    cout << 6 * combinations << "\n";
}
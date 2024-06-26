// RUN: rm -rf %t
// RUN: split-file %s %t

// Setup framework root
// RUN: mkdir -p %t/Frameworks/MyFramework.framework/Headers
// RUN: cp %t/MyFramework.h %t/Frameworks/MyFramework.framework/Headers/
// RUN: cp %t/MyHeader.h %t/Frameworks/MyFramework.framework/Headers/

// RUN: sed -e "s@SRCROOT@%{/t:regex_replacement}@g" \
// RUN: %t/reference.output.json.in >> %t/reference.output.json

// Create VFS overlay from framework headers to SRCROOT
// RUN: sed -e "s@SRCROOT@%{/t:regex_replacement}@g" -e "s@DSTROOT@%{/t:regex_replacement}@g" \
// RUN: %t/vfsoverlay.yaml.in >> %t/vfsoverlay.yaml

// Input headers use paths to the framework root/DSTROOT
// RUN: %clang_cc1 -extract-api --pretty-sgf -v --product-name=MyFramework \
// RUN: -triple arm64-apple-macosx \
// RUN: -iquote%t -ivfsoverlay %t/vfsoverlay.yaml -F%t/Frameworks \
// RUN: -x objective-c-header \
// RUN: %t/Frameworks/MyFramework.framework/Headers/MyFramework.h \
// RUN: %t/Frameworks/MyFramework.framework/Headers/MyHeader.h \
// RUN: %t/QuotedHeader.h \
// RUN: -o %t/output.json 2>&1 -verify | FileCheck -allow-empty %s

// Generator version is not consistent across test runs, normalize it.
// RUN: sed -e "s@\"generator\": \".*\"@\"generator\": \"?\"@g" \
// RUN: %t/output.json >> %t/output-normalized.json
// RUN: diff %t/reference.output.json %t/output-normalized.json

// CHECK:      <extract-api-includes>:
// CHECK-NEXT: #import <MyFramework/MyFramework.h>
// CHECK-NEXT: #import <MyFramework/MyHeader.h>
// CHECK-NEXT: #import "QuotedHeader.h"

//--- vfsoverlay.yaml.in
{
    "case-sensitive": "false",
    "roots": [
        {
            "contents": [
                {
                    "external-contents": "SRCROOT/MyHeader.h",
                    "name": "MyHeader.h",
                    "type": "file"
                }
            ],
            "name": "DSTROOT/Frameworks/MyFramework.framework/Headers",
            "type": "directory"
        }
    ],
    "version": 0
}

//--- MyFramework.h
// Umbrella for MyFramework
#import <MyFramework/MyHeader.h>
// expected-no-diagnostics

//--- MyHeader.h
#import <OtherFramework/OtherHeader.h>
int MyInt;
// expected-no-diagnostics

//--- QuotedHeader.h
char MyChar;
// expected-no-diagnostics

//--- Frameworks/OtherFramework.framework/Headers/OtherHeader.h
int OtherInt;
// expected-no-diagnostics

//--- reference.output.json.in
{
  "metadata": {
    "formatVersion": {
      "major": 0,
      "minor": 5,
      "patch": 3
    },
    "generator": "?"
  },
  "module": {
    "name": "MyFramework",
    "platform": {
      "architecture": "arm64",
      "operatingSystem": {
        "minimumVersion": {
          "major": 11,
          "minor": 0,
          "patch": 0
        },
        "name": "macosx"
      },
      "vendor": "apple"
    }
  },
  "relationships": [],
  "symbols": [
    {
      "accessLevel": "public",
      "declarationFragments": [
        {
          "kind": "typeIdentifier",
          "preciseIdentifier": "c:I",
          "spelling": "int"
        },
        {
          "kind": "text",
          "spelling": " "
        },
        {
          "kind": "identifier",
          "spelling": "MyInt"
        },
        {
          "kind": "text",
          "spelling": ";"
        }
      ],
      "identifier": {
        "interfaceLanguage": "objective-c",
        "precise": "c:@MyInt"
      },
      "kind": {
        "displayName": "Global Variable",
        "identifier": "objective-c.var"
      },
      "location": {
        "position": {
          "character": 4,
          "line": 1
        },
        "uri": "file://SRCROOT/MyHeader.h"
      },
      "names": {
        "navigator": [
          {
            "kind": "identifier",
            "spelling": "MyInt"
          }
        ],
        "subHeading": [
          {
            "kind": "identifier",
            "spelling": "MyInt"
          }
        ],
        "title": "MyInt"
      },
      "pathComponents": [
        "MyInt"
      ]
    },
    {
      "accessLevel": "public",
      "declarationFragments": [
        {
          "kind": "typeIdentifier",
          "preciseIdentifier": "c:C",
          "spelling": "char"
        },
        {
          "kind": "text",
          "spelling": " "
        },
        {
          "kind": "identifier",
          "spelling": "MyChar"
        },
        {
          "kind": "text",
          "spelling": ";"
        }
      ],
      "identifier": {
        "interfaceLanguage": "objective-c",
        "precise": "c:@MyChar"
      },
      "kind": {
        "displayName": "Global Variable",
        "identifier": "objective-c.var"
      },
      "location": {
        "position": {
          "character": 5,
          "line": 0
        },
        "uri": "file://SRCROOT/QuotedHeader.h"
      },
      "names": {
        "navigator": [
          {
            "kind": "identifier",
            "spelling": "MyChar"
          }
        ],
        "subHeading": [
          {
            "kind": "identifier",
            "spelling": "MyChar"
          }
        ],
        "title": "MyChar"
      },
      "pathComponents": [
        "MyChar"
      ]
    }
  ]
}

package com.cld.model;

public enum Priority {
    URGENT_IMPORTANT,           // Red - Quan trọng, Khẩn cấp
    NOT_URGENT_NOT_IMPORTANT,   // Yellow - Không quan trọng, Không khẩn cấp
    IMPORTANT_NOT_URGENT,       // Blue - Quan trọng, Không khẩn cấp
    NOT_IMPORTANT_URGENT,       // Green - Không quan trọng, Khẩn cấp
    SPECIAL                     // Purple - Ngày đặc biệt
}
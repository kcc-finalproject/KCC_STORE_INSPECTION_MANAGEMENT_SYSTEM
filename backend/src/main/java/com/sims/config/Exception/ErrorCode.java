package com.sims.config.Exception;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
@AllArgsConstructor
public enum ErrorCode {

    SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "COMMON-001", "서버 에러, 관리자에게 문의 바랍니다."),


    DUPLICATE_RESOURCE(HttpStatus.CONFLICT, "DATA-001", "데이터가 이미 존재합니다."), // 409
    NOT_FOUND(HttpStatus.NOT_FOUND, "DATA-002", "데이터가 존재하지 않습니다."), // 404
    INVALID_PARAMETER(HttpStatus.BAD_REQUEST, "DATA-003", "파라미터가 유효하지 않습니다."),
    INVALID_INPUT_VALUE(HttpStatus.BAD_REQUEST, "DATA-004", "입력값이 유효하지 않습니다."),

    HAS_EMAIL(HttpStatus.BAD_REQUEST, "ACCOUNT-001", "이미 존재하는 사원번호입니다."),

    HANDLE_ACCESS_DENIED(HttpStatus.FORBIDDEN, "AUTH-001", "권한이 없습니다."),

    CHECKLIST_IN_USE(HttpStatus.CONFLICT, "DATA-001", "사용중인 체크리스트입니다."), // 409
    ;

    private final HttpStatus httpStatus;
    private final String code;
    private final String message;
}
